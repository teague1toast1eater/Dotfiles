-- Small stand-ins for the Omarchy `o.*` helpers, built on stock tools.
-- Edit `o.apps` to match what's installed on this machine.

o = o or {}

local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function o.shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end
local q = o.shell_quote

function o.cmd_present(command)
	if command:find("/", 1, true) then
		return file_exists(command)
	end
	local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
	for directory in (path .. ":"):gmatch("([^:]*):") do
		if file_exists((directory ~= "" and directory or ".") .. "/" .. command) then
			return true
		end
	end
	return false
end

-- First installed command from a list.
local function first_present(candidates)
	for _, candidate in ipairs(candidates) do
		if o.cmd_present(candidate) then
			return candidate
		end
	end
	return candidates[1]
end

-- Preferred apps. First installed entry wins; override any of these directly.
o.apps = {
	terminal = first_present({ "ghostty", "alacritty", "kitty", "foot" }),
	browser = first_present({ "chromium", "brave", "google-chrome-stable", "firefox" }),
	file_manager = first_present({ "nautilus", "thunar", "dolphin" }),
	editor = os.getenv("EDITOR") or "nvim",
	-- Launchers in --dmenu mode drive the wallpaper picker, power menu, etc.
	launcher = first_present({ "walker", "fuzzel", "rofi", "wofi" }),
}

-- uwsm-app keeps apps in their own systemd scope; fall back to plain exec.
local uwsm = o.cmd_present("uwsm-app")
function o.launch(command)
	if uwsm then
		return "uwsm-app -- " .. command
	end
	return command
end

function o.terminal(args)
	local term = o.apps.terminal
	if args == nil or args == "" then
		return o.launch(term)
	end
	-- ghostty/alacritty/kitty/foot all accept `-e cmd...`.
	return o.launch(term .. " -e " .. args)
end

-- Terminal in the focused terminal's working directory (Omarchy-style).
function o.terminal_cwd(args)
	local cmd = "hypr-terminal-cwd " .. o.shell_quote(o.apps.terminal)
	if args and args ~= "" then
		cmd = cmd .. " -e " .. args
	end
	return o.launch(cmd)
end

function o.tui(command)
	return o.terminal(command)
end

local chromium_like = {
	chromium = true,
	brave = true,
	["google-chrome-stable"] = true,
}

function o.browser(flags)
	return o.launch(o.apps.browser .. (flags and (" " .. flags) or ""))
end

function o.browser_private()
	if chromium_like[o.apps.browser] then
		return o.browser("--incognito")
	end
	return o.browser("--private-window")
end

-- Omarchy web apps are Chromium `--app` windows; Firefox just opens a window.
function o.launch_webapp(url)
	if chromium_like[o.apps.browser] then
		return o.browser("--app=" .. q(url))
	end
	return o.browser("--new-window " .. q(url))
end

-- Focus a window whose class or title matches `pattern` (a Lua pattern, ^ and
-- $ work), or run `command` if none is open.
function o.launch_or_focus(pattern, command)
	return function()
		for _, window in ipairs(hl.get_windows() or {}) do
			local class = window.class or ""
			local title = window.title or ""
			if class:lower():find(pattern) or title:lower():find(pattern) then
				hl.dispatch(hl.dsp.focus({ window = "address:" .. window.address }))
				return
			end
		end
		hl.exec_cmd(command)
	end
end

-- Pipe newline-separated stdin into the launcher and print the choice.
function o.dmenu(prompt)
	local l = o.apps.launcher
	if l == "walker" then
		return "walker --dmenu -p " .. q(prompt)
	elseif l == "fuzzel" then
		return "fuzzel --dmenu -p " .. q(prompt .. " ")
	elseif l == "rofi" then
		return "rofi -dmenu -p " .. q(prompt)
	end
	return "wofi --dmenu -p " .. q(prompt)
end

function o.app_launcher()
	local l = o.apps.launcher
	if l == "walker" then
		return "walker"
	elseif l == "fuzzel" then
		return "fuzzel"
	elseif l == "rofi" then
		return "rofi -show drun"
	end
	return "wofi --show drun"
end

function o.bind(keys, description, dispatcher, options)
	local opts = options or {}
	if description then
		opts.description = description
	end
	if type(dispatcher) == "string" then
		dispatcher = hl.dsp.exec_cmd(dispatcher)
	end
	hl.bind(keys, dispatcher, opts)
end

function o.rebind(keys, description, dispatcher, options)
	hl.unbind(keys)
	o.bind(keys, description, dispatcher, options)
end

function o.exec_on_start(command)
	hl.on("hyprland.start", function()
		hl.exec_cmd(command)
	end)
end

-- Run `command` at startup only if `binary` is installed.
function o.start_if_present(binary, command)
	if o.cmd_present(binary) then
		o.exec_on_start(command or o.launch(binary))
	end
end

function o.window(match, rules)
	rules.match = rules.match or {}
	if type(match) == "string" then
		rules.match.class = match
	else
		for key, value in pairs(match) do
			rules.match[key] = value
		end
	end
	hl.window_rule(rules)
end
