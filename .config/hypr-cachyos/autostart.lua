-- Startup programs. Each one starts only if it's installed.

o.exec_on_start("wallpaper restore")

o.start_if_present("waybar")
o.start_if_present("swaync")
o.start_if_present("mako")
o.start_if_present("hypridle")
o.start_if_present("swayosd-server")
o.start_if_present("wl-paste", "wl-paste --watch cliphist store")
o.start_if_present("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
o.start_if_present("/usr/lib/hyprpolkitagent/hyprpolkitagent")

-- Extra autostart processes.
-- o.exec_on_start(o.launch("my-service"))
