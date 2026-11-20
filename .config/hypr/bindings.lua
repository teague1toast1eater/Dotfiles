-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Ported from the old bindings.conf (Hyprland now only reads the .lua files).
-- Each key is unbound first so these replace Omarchy's defaults.
local function rebind(keys, description, command)
	hl.unbind(keys)
	o.bind(keys, description, command)
end

local cwd = '"$(omarchy-cmd-terminal-cwd)"'

-- Application bindings
rebind("SUPER + RETURN", "Terminal", "uwsm-app -- xdg-terminal-exec --dir=" .. cwd)
rebind(
	"SUPER + ALT + RETURN",
	"Tmux",
	"uwsm-app -- xdg-terminal-exec --dir=" .. cwd .. ' bash -c "tmux attach || tmux new -s Work"'
)
rebind("SUPER + SHIFT + RETURN", "Browser", "omarchy-launch-browser")
rebind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
rebind("SUPER + ALT + SHIFT + F", "File manager (cwd)", "uwsm-app -- nautilus --new-window " .. cwd)
rebind("SUPER + SHIFT + ALT + B", "Browser (private)", "omarchy-launch-browser --private")
rebind("SUPER + SHIFT + M", "Music", "omarchy-launch-or-focus spotify")
rebind("SUPER + SHIFT + ALT + M", "Music TUI", "omarchy-launch-or-focus-tui cliamp")
rebind("SUPER + SHIFT + N", "Editor", "omarchy-launch-editor")
rebind("SUPER + SHIFT + D", "Docker", "omarchy-launch-tui lazydocker")
rebind("SUPER + SHIFT + G", "Signal", 'omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"')
rebind("SUPER + SHIFT + O", "Obsidian", 'omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"')
rebind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")
rebind("SUPER + SHIFT + SLASH", "Passwords", "uwsm-app -- 1password")
rebind("SUPER + ALT + D", "Discord", 'omarchy-launch-or-focus ^discord$ "uwsm-app -- discord"')
rebind("SUPER + SHIFT + S", "Steam", 'omarchy-launch-or-focus ^steam$ "uwsm-app -- steam"')
rebind("SUPER + SHIFT + E", "Email", 'omarchy-launch-or-focus ^thunderbird$ "uwsm-app -- thunderbird"')
rebind("SUPER + SHIFT + A", "Claude", o.launch_webapp("https://claude.ai/login"))
rebind("SUPER + SHIFT + C", "CyberChef", o.launch_webapp("https://gchq.github.io/CyberChef/"))
rebind("SUPER + SHIFT + Y", "YouTube", o.launch_webapp("https://youtube.com/"))

-- -- Sync workspace switching across all monitors
-- local switch_all = "~/.config/hypr/scripts/switch-workspace-all.sh "
-- for workspace = 1, 10 do
--   rebind("SUPER + code:" .. (workspace + 9), "Switch to workspace " .. workspace .. " (all monitors)", switch_all .. workspace)
-- end
-- rebind("SUPER + TAB", "Next workspace (all monitors)", switch_all .. "e+1")
-- rebind("SUPER + SHIFT + TAB", "Previous workspace (all monitors)", switch_all .. "e-1")
-- rebind("SUPER + CTRL + TAB", "Former workspace (all monitors)", switch_all .. "previous")
-- rebind("SUPER + mouse_down", "Scroll workspace forward (all monitors)", switch_all .. "e+1")
-- rebind("SUPER + mouse_up", "Scroll workspace backward (all monitors)", switch_all .. "e-1")
