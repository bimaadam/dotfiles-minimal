#!/usr/bin/env bash

TARGET_DIR="$HOME/Pictures"
mkdir -p "$TARGET_DIR"
FILENAME="$TARGET_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

case "${1:-full}" in
    full)
        grim "$FILENAME"
        if [[ -s "$FILENAME" ]]; then
            wl-copy --type image/png < "$FILENAME"
        fi
        ;;
    area)
        GEOM=$(slurp 2>/dev/null)
        if [[ -n "$GEOM" ]]; then
            grim -g "$GEOM" "$FILENAME"
            if [[ -s "$FILENAME" ]]; then
                wl-copy --type image/png < "$FILENAME"
            fi
        fi
        ;;
esac
