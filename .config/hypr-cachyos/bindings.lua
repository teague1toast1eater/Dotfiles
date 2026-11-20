-- Keybindings mirroring the Omarchy machine: Omarchy's defaults plus the
-- personal overrides from ../hypr/bindings.lua, rewritten for stock tools.
-- Omarchy-only features (shell panels, theme menu, etc.) are left out or
-- mapped to the closest standard tool.
--
-- List all bindings with: SUPER + K (or `hyprctl binds`)

---------------------------------------------------------------------------
-- Applications (Omarchy defaults + personal overrides)
---------------------------------------------------------------------------
o.bind("SUPER + RETURN", "Terminal", o.terminal_cwd())
o.bind("SUPER + ALT + RETURN", "Tmux", o.terminal_cwd('bash -c "tmux attach || tmux new -s Work"'))
o.bind("SUPER + SHIFT + RETURN", "Browser", o.browser())
o.bind("SUPER + SHIFT + B", "Browser", o.browser())
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", o.browser_private())
o.bind("SUPER + SHIFT + F", "File manager", o.launch(o.apps.file_manager .. " --new-window"))
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", o.launch(o.apps.file_manager .. ' --new-window "$(hypr-terminal-cwd --print)"'))
o.bind("SUPER + SHIFT + N", "Editor", o.terminal(o.apps.editor))
o.bind("SUPER + SHIFT + T", "Activity", o.tui("btop"))
o.bind("SUPER + SHIFT + M", "Music", o.launch_or_focus("spotify", o.launch("spotify")))
o.bind("SUPER + SHIFT + ALT + M", "Music TUI", o.tui("cliamp"))
o.bind("SUPER + SHIFT + D", "Docker", o.tui("lazydocker"))
o.bind("SUPER + SHIFT + G", "Signal", o.launch_or_focus("^signal$", o.launch("signal-desktop")))
o.bind("SUPER + SHIFT + O", "Obsidian", o.launch_or_focus("^obsidian$", o.launch("obsidian")))
o.bind("SUPER + SHIFT + W", "Typora", o.launch("typora --enable-wayland-ime"))
o.bind("SUPER + SHIFT + SLASH", "Passwords", o.launch("1password"))
o.bind("SUPER + ALT + D", "Discord", o.launch_or_focus("^discord$", o.launch("discord")))
o.bind("SUPER + SHIFT + S", "Steam", o.launch_or_focus("^steam$", o.launch("steam")))
o.bind("SUPER + SHIFT + E", "Email", o.launch_or_focus("^thunderbird$", o.launch("thunderbird")))
o.bind("SUPER + SHIFT + A", "Claude", o.launch_webapp("https://claude.ai/login"))
o.bind("SUPER + SHIFT + C", "CyberChef", o.launch_webapp("https://gchq.github.io/CyberChef/"))
o.bind("SUPER + SHIFT + Y", "YouTube", o.launch_webapp("https://youtube.com/"))
o.bind("SUPER + SHIFT + Q", "Calculator", o.launch("gnome-calculator"))
o.bind("XF86Calculator", "Calculator", o.launch("gnome-calculator"))

---------------------------------------------------------------------------
-- Windows
---------------------------------------------------------------------------
o.bind("SUPER + W", "Close window", hl.dsp.window.close())
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Close all windows", function()
	for _, window in ipairs(hl.get_windows() or {}) do
		hl.dispatch(hl.dsp.window.close({ window = "address:" .. window.address }))
	end
end)

o.bind("SUPER + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + P", "Pseudo window", hl.dsp.window.pseudo())
o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + O", "Pop window out (float & pin)", function()
	local window = hl.get_active_window()
	if not window then
		return
	end
	if not window.floating then
		hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	end
	hl.dispatch(hl.dsp.window.pin())
end)

o.bind("SUPER + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + SHIFT + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.alter_zorder({ mode = "bottom" }))
o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

local function resize(keys, label, x, y)
	o.bind(keys, label, hl.dsp.window.resize({ x = x, y = y, relative = true }))
end
for _, step in ipairs({ { "", 100, "" }, { "ALT + ", 25, " a little" }, { "CTRL + ", 300, " a lot" } }) do
	local mod, px, suffix = step[1], step[2], step[3]
	resize("SUPER + " .. mod .. "minus", "Expand window left" .. suffix, -px, 0)
	resize("SUPER + " .. mod .. "equal", "Shrink window left" .. suffix, px, 0)
	resize("SUPER + SHIFT + " .. mod .. "minus", "Shrink window up" .. suffix, 0, -px)
	resize("SUPER + SHIFT + " .. mod .. "equal", "Expand window down" .. suffix, 0, px)
end

o.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
o.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

---------------------------------------------------------------------------
-- Workspaces and monitors
---------------------------------------------------------------------------
for workspace = 1, 10 do
	local key = tostring(workspace % 10)
	local ws = tostring(workspace)
	o.bind("SUPER + " .. key, "Switch to workspace " .. ws, hl.dsp.focus({ workspace = ws }))
	o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. ws, hl.dsp.window.move({ workspace = ws }))
	o.bind(
		"SUPER + SHIFT + ALT + " .. key,
		"Move window silently to workspace " .. ws,
		hl.dsp.window.move({ workspace = ws, follow = false })
	)
end

o.bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "m+1" }))
o.bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "m-1" }))
o.bind("SUPER + CTRL + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous_per_monitor" }))
o.bind("SUPER + mouse_down", "Scroll active workspace forward", hl.dsp.focus({ workspace = "m+1" }))
o.bind("SUPER + mouse_up", "Scroll active workspace backward", hl.dsp.focus({ workspace = "m-1" }))

o.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
o.bind("SUPER + grave", "Toggle Quake console", hl.dsp.workspace.toggle_special("qconsole"))
o.bind("SUPER + SHIFT + grave", "Move window to Quake console", hl.dsp.window.move({ workspace = "special:qconsole", follow = false }))

for dir, name in pairs({ l = "left", r = "right", u = "up", d = "down" }) do
	local KEY = name:upper()
	o.bind("SUPER + SHIFT + ALT + " .. KEY, "Move workspace to " .. name .. " monitor", hl.dsp.workspace.move({ monitor = dir }))
	o.bind("SUPER + SHIFT + CTRL + " .. KEY, "Move window to " .. name .. " monitor", hl.dsp.window.move({ monitor = dir }))
end

o.bind("CTRL + ALT + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("CTRL + ALT + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

---------------------------------------------------------------------------
-- Groups
---------------------------------------------------------------------------
o.bind("SUPER + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("SUPER + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))
o.bind("SUPER + ALT + LEFT", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + RIGHT", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + UP", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + DOWN", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))
o.bind("SUPER + ALT + TAB", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())
o.bind("SUPER + CTRL + LEFT", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("SUPER + CTRL + RIGHT", "Move grouped window focus right", hl.dsp.group.next())
o.bind("SUPER + ALT + mouse_down", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + ALT + mouse_up", "Previous window in group", hl.dsp.group.prev())
for index = 1, 5 do
	o.bind("SUPER + ALT + " .. tostring(index), "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
end

---------------------------------------------------------------------------
-- Menus, launcher, wallpaper (Omarchy menus -> launcher-based scripts)
---------------------------------------------------------------------------
o.bind("SUPER + SPACE", "App launcher", o.app_launcher())
o.bind("SUPER + ALT + SPACE", "Apps", o.app_launcher())
o.bind("SUPER + ESCAPE", "System menu", "hypr-power-menu")
o.bind("XF86PowerOff", "Power menu", "hypr-power-menu", { locked = true })
o.bind("SUPER + K", "Keybindings", "hypr-keybindings")

o.bind("SUPER + CTRL + SPACE", "Background switcher", "wallpaper pick")
o.bind("SUPER + CTRL + W", "Background switcher", "wallpaper pick")
o.bind("SUPER + SHIFT + CTRL + W", "Next background", "wallpaper next")

o.bind("SUPER + SHIFT + SPACE", "Toggle top bar", "pkill -SIGUSR1 waybar")
o.bind("SUPER + CTRL + L", "Lock system", "loginctl lock-session")
o.bind("SUPER + CTRL + I", "Toggle locking on idle", "pkill hypridle || " .. o.launch("hypridle"))

-- Notifications (swaync or mako, whichever is running).
o.bind("SUPER + comma", "Dismiss last notification", "swaync-client --close-latest || makoctl dismiss")
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "swaync-client --close-all || makoctl dismiss --all")
o.bind("SUPER + SHIFT + ALT + comma", "Open notification history", "swaync-client -t -sw || makoctl restore")
o.bind("SUPER + CTRL + ALT + comma", "Toggle silencing notifications", "swaync-client -d -sw || makoctl mode -t do-not-disturb")

-- Settings panels -> standard apps.
o.bind("SUPER + CTRL + A", "Audio", o.launch_or_focus("pavucontrol", o.launch("pavucontrol")))
o.bind("SUPER + CTRL + B", "Bluetooth", o.launch_or_focus("blueman", o.launch("blueman-manager")))
o.bind("SUPER + CTRL + N", "Network", o.tui("nmtui"))
o.bind("SUPER + CTRL + ALT + T", "Show time", "notify-send -u low \"$(date +'%A %H:%M  —  %d %B %Y')\"")
o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", "notify-send -u low \"Battery $(cat /sys/class/power_supply/BAT*/capacity | head -1)%\"")

o.bind("SUPER + CTRL + Z", "Zoom in", function()
	local zoom = hl.get_config("cursor.zoom_factor") or 1
	hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
	hl.config({ cursor = { zoom_factor = 1 } })
end)

---------------------------------------------------------------------------
-- Capture
---------------------------------------------------------------------------
local shots = '"$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"'
local screenshot = "mkdir -p \"$(xdg-user-dir PICTURES)/Screenshots\" && f=" .. shots
	.. ' && grim -g "$(slurp -d)" "$f" && wl-copy < "$f" && notify-send -u low "Screenshot copied" "$f"'
o.bind("PRINT", "Screenshot", screenshot)
o.bind("SUPER + CTRL + ALT + C", "Screenshot", screenshot)
o.bind("SHIFT + PRINT", "Screenshot full screen", "grim - | wl-copy && notify-send -u low 'Screenshot copied'")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + V", "Clipboard manager", "cliphist list | " .. o.dmenu("Clipboard") .. " | cliphist decode | wl-copy")

---------------------------------------------------------------------------
-- Media, volume, brightness
---------------------------------------------------------------------------
local locked_repeat = { locked = true, repeating = true }
local locked = { locked = true }
o.bind("XF86AudioRaiseVolume", "Volume up", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", locked_repeat)
o.bind("XF86AudioLowerVolume", "Volume down", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", locked_repeat)
o.bind("XF86AudioMute", "Mute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", locked)
o.bind("XF86AudioMicMute", "Mute microphone", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", locked)
o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+", locked_repeat)
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-", locked_repeat)

o.bind("XF86MonBrightnessUp", "Brightness up", "brightnessctl -e4 -n2 set 5%+", locked_repeat)
o.bind("XF86MonBrightnessDown", "Brightness down", "brightnessctl -e4 -n2 set 5%-", locked_repeat)
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "brightnessctl set 100%", locked_repeat)
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "brightnessctl set 1%", locked_repeat)
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", "brightnessctl set 1%+", locked_repeat)
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", "brightnessctl set 1%-", locked_repeat)
local kbd = "brightnessctl -d '*::kbd_backlight' set "
o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", kbd .. "33%+", locked_repeat)
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", kbd .. "33%-", locked_repeat)

o.bind("XF86AudioNext", "Next track", "playerctl next", locked)
o.bind("ALT + XF86AudioPlay", "Next track", "playerctl next", locked)
o.bind("XF86AudioPause", "Pause", "playerctl play-pause", locked)
o.bind("XF86AudioPlay", "Play", "playerctl play-pause", locked)
o.bind("XF86AudioPrev", "Previous track", "playerctl previous", locked)
o.bind("ALT + SHIFT + XF86AudioPlay", "Previous track", "playerctl previous", locked)
o.bind("XF86Eject", "Eject media", "eject", locked)

---------------------------------------------------------------------------
-- Universal clipboard (SUPER + C/V/X/A), as on Omarchy
---------------------------------------------------------------------------
local function send_shortcut_once(mods, key)
	return function()
		hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
		hl.timer(function()
			hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
		end, { timeout = 50, type = "oneshot" })
	end
end

local terminal_classes = { "ghostty", "alacritty", "kitty", "foot", "wezterm", "konsole" }
local function active_window_is_terminal()
	local window = hl.get_active_window()
	local class = window and (window.class or ""):lower() or ""
	for _, term in ipairs(terminal_classes) do
		if class:find(term, 1, true) then
			return true
		end
	end
	return false
end

local function universal(default_mods, default_key, terminal_mods, terminal_key)
	return function()
		if active_window_is_terminal() then
			send_shortcut_once(terminal_mods, terminal_key)()
		else
			send_shortcut_once(default_mods, default_key)()
		end
	end
end

o.bind("SUPER + A", "Select all", send_shortcut_once("CTRL", "A"))
o.bind("SUPER + C", "Universal copy", universal("CTRL", "C", "CTRL SHIFT", "C"))
o.bind("SUPER + V", "Universal paste", universal("CTRL", "V", "CTRL SHIFT", "V"))
o.bind("SUPER + X", "Universal cut", send_shortcut_once("CTRL", "X"))
