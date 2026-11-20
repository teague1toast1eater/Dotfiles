-- Standalone Hyprland config for CachyOS (no Omarchy installed).
--
-- Mirrors the keybindings and feel of the Omarchy config in ../hypr, but uses
-- only stock tools (wpctl, brightnessctl, playerctl, grim/slurp, hyprlock, ...)
-- plus the small helper scripts in ~/.local/bin from this dotfiles repo.
--
-- `make install` links ~/.config/hypr to this directory on non-Omarchy hosts.

local home = os.getenv("HOME")
local config_home = os.getenv("XDG_CONFIG_HOME")
if config_home == nil or config_home == "" then
	config_home = home .. "/.config"
end

-- Drop cached modules so `hyprctl reload` picks up edits.
for module in pairs(package.loaded) do
	if module == "hypr" or module:sub(1, 5) == "hypr." then
		package.loaded[module] = nil
	end
end

package.path = config_home .. "/?.lua;" .. package.path

require("hypr.helpers")
require("hypr.monitors")
require("hypr.input")
require("hypr.looknfeel")
require("hypr.windows")
require("hypr.bindings")
require("hypr.autostart")
