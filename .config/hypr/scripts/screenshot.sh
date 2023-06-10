#!/usr/bin/env bash

TARGET_DIR="$HOME/Pictures"
mkdir -p "$TARGET_DIR"
FILENAME="$TARGET_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

notify_user() {
    if command -v notify-send >/dev/null 2>&1 && (pgrep -x dunst >/dev/null 2>&1 || pgrep -x mako >/dev/null 2>&1 || pgrep -x swaync >/dev/null 2>&1); then
        notify-send -t 1500 -u low "Screenshot saved"
    elif command -v hyprctl >/dev/null 2>&1; then
        hyprctl notify 0 1500 "rgb(ffffff)" "Screenshot saved"
    fi
}

case "${1:-full}" in
    full)
        grim "$FILENAME"
        if [[ -s "$FILENAME" ]]; then
            wl-copy --type image/png < "$FILENAME"
            notify_user
        fi
        ;;
    area)
        GEOM=$(slurp 2>/dev/null)
        if [[ -n "$GEOM" ]]; then
            grim -g "$GEOM" "$FILENAME"
            if [[ -s "$FILENAME" ]]; then
                wl-copy --type image/png < "$FILENAME"
                notify_user
            fi
        fi
        ;;
esac
