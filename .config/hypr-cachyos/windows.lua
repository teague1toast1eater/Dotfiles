-- Window rules. Find a window's class with: hyprctl clients

-- Settings/utility windows float, like Omarchy's panels.
for _, class in ipairs({
	"org.pulseaudio.pavucontrol",
	"blueman-manager",
	"nm-connection-editor",
	"org.gnome.Calculator",
	"xdg-desktop-portal-gtk",
}) do
	o.window(class, { float = true, center = true, size = { 875, 600 } })
end

-- Quake console: a terminal on special:qconsole (SUPER + `).
hl.on("workspace.created", function(ws)
	if ws and ws.name == "special:qconsole" and ws.is_empty then
		hl.exec_cmd(o.terminal(), { workspace = "special:qconsole silent" })
	end
end)
hl.config({ decoration = { dim_special = 0.6 } })
