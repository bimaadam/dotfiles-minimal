#!/usr/bin/env bash

STATE_FILE="/tmp/hypr_anim_mode"
CURRENT="cinematic"

if [[ -f "$STATE_FILE" ]]; then
    CURRENT=$(cat "$STATE_FILE")
fi

notify_user() {
    local mode="$1"
    if command -v notify-send >/dev/null 2>&1 && (pgrep -x dunst >/dev/null 2>&1 || pgrep -x mako >/dev/null 2>&1 || pgrep -x swaync >/dev/null 2>&1); then
        notify-send -t 1500 -u low "Animations" "$mode"
    elif command -v hyprctl >/dev/null 2>&1; then
        hyprctl notify 0 1500 "rgb(ffffff)" "Animations: $mode"
    fi
}

if [[ "$CURRENT" == "cinematic" ]]; then
    # Switch to Default Hyprland animations
    hyprctl eval '
        hl.animation({ leaf = "windows",     enabled = true, speed = 7, bezier = "default" })
        hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7, bezier = "default" })
        hl.animation({ leaf = "windowsMove", enabled = true, speed = 7, bezier = "default" })
        hl.animation({ leaf = "fade",        enabled = true, speed = 7, bezier = "default" })
        hl.animation({ leaf = "workspaces",  enabled = true, speed = 7, bezier = "default", style = "slide" })
    ' >/dev/null 2>&1
    echo "default" > "$STATE_FILE"
    notify_user "Default"
else
    # Switch to Smooth Cinematic animations
    hyprctl eval '
        hl.animation({ leaf = "windows",     enabled = true, speed = 5,   bezier = "fluid", style = "popin 80%" })
        hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4,   bezier = "fluid", style = "popin 80%" })
        hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,   bezier = "fluid" })
        hl.animation({ leaf = "fade",        enabled = true, speed = 4.5, bezier = "fluid" })
        hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,   bezier = "fluid", style = "slidefade 30%" })
    ' >/dev/null 2>&1
    echo "cinematic" > "$STATE_FILE"
    notify_user "Smooth Cinematic"
fi
