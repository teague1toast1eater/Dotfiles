-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

hl.env("GDK_SCALE", "1")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Layout from the Omarchy laptop. Output names differ between machines, so
-- check `hyprctl monitors all` before uncommenting.
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x1080", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "1920x0", scale = 1 })
