#!/bin/bash
# Enable/disable the internal laptop keyboard based on whether any external
# (USB/Bluetooth) keyboard is currently connected. Triggered by udev on
# keyboard add/remove; safe to also run manually or from an autostart entry.

DEVICE="at-translated-set-2-keyboard"

external_count=$(/usr/bin/udevadm info -e | /usr/bin/awk '
  /^P: / { bus=""; kbd=0 }
  /^E: ID_BUS=/ { bus=$0 }
  /^E: ID_INPUT_KEYBOARD=1/ { kbd=1 }
  /^$/ { if (kbd && (bus ~ /usb/ || bus ~ /bluetooth/)) count++ }
  END { print count+0 }
')

if [ "$external_count" -gt 0 ]; then
    value=false
else
    value=true
fi

for runtime_dir in /run/user/*; do
    [ -d "$runtime_dir/hypr" ] || continue
    uid="${runtime_dir##*/}"
    for sig_dir in "$runtime_dir"/hypr/*/; do
        [ -d "$sig_dir" ] || continue
        sig="$(basename "$sig_dir")"
        if [ "$(id -u)" = "$uid" ]; then
            XDG_RUNTIME_DIR="$runtime_dir" HYPRLAND_INSTANCE_SIGNATURE="$sig" \
                /usr/bin/hyprctl keyword "device[$DEVICE]:enabled" "$value" >/dev/null 2>&1
        else
            user="$(id -un "$uid" 2>/dev/null)" || continue
            /usr/bin/runuser -u "$user" -- env XDG_RUNTIME_DIR="$runtime_dir" HYPRLAND_INSTANCE_SIGNATURE="$sig" \
                /usr/bin/hyprctl keyword "device[$DEVICE]:enabled" "$value" >/dev/null 2>&1
        fi
    done
done
