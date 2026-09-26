#!/bin/bash
# Synchronized workspace switching for dual monitors.
# Laptop (eDP-1) uses workspaces 1-10; external (DP-1) uses 11-20 as paired slots.
# SUPER+1 → laptop workspace 1, external workspace 11 (both update together).

TARGET="$1"
LAPTOP="eDP-1"
EXTERNAL="DP-1"
HISTORY_FILE="/tmp/hypr-ws-history"

get_laptop_ws() {
    hyprctl monitors -j | jq -r --arg m "$LAPTOP" '.[] | select(.name==$m) | .activeWorkspace.id'
}

external_connected() {
    hyprctl monitors -j | jq -e --arg m "$EXTERNAL" '.[] | select(.name==$m)' > /dev/null 2>&1
}

case "$TARGET" in
    e+1)
        CUR=$(get_laptop_ws)
        TARGET=$((CUR + 1))
        [[ $TARGET -gt 10 ]] && TARGET=1
        ;;
    e-1)
        CUR=$(get_laptop_ws)
        TARGET=$((CUR - 1))
        [[ $TARGET -lt 1 ]] && TARGET=10
        ;;
    previous)
        TARGET=$(cat "$HISTORY_FILE" 2>/dev/null || echo "1")
        ;;
esac

# Save current workspace before switching (for "previous")
get_laptop_ws > "$HISTORY_FILE"

FOCUSED=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

if external_connected; then
    EXT_TARGET=$((TARGET + 10))
    hyprctl dispatch focusmonitor "$LAPTOP"
    hyprctl dispatch workspace "$TARGET"
    hyprctl dispatch focusmonitor "$EXTERNAL"
    hyprctl dispatch workspace "$EXT_TARGET"
else
    hyprctl dispatch workspace "$TARGET"
fi

hyprctl dispatch focusmonitor "$FOCUSED"
