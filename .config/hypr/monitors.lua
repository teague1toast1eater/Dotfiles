-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Bottom-aligned: laptop sits next to the bottom half of the 4K
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x1080", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "1920x0", scale = 1 })

-- Centered vertically: crossing happens in the middle of the 4K
--   eDP-1 position = "0x540"

-- Laptop below the monitor: move the cursor down to cross instead of sideways
--   HDMI-A-1 position = "0x0", eDP-1 position = "960x2160"  (centered under it)

-- Laptop on the left side of the monitor instead of the right
--   HDMI-A-1 position = "0x0", eDP-1 position = "3840x1080"

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
