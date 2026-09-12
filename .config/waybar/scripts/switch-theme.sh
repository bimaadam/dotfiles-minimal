#!/usr/bin/env bash

THEME_DIR="$HOME/.config/waybar/themes"
ACTIVE_THEME_FILE="$HOME/.config/waybar/current_theme"

# Read current theme
current="default"
if [ -f "$ACTIVE_THEME_FILE" ]; then
    current=$(cat "$ACTIVE_THEME_FILE" | tr -d '[:space:]')
fi

# Determine target theme
target="$1"
if [ -z "$target" ] || [ "$target" = "toggle" ]; then
    if [ "$current" = "macos" ]; then
        target="default"
    else
        target="macos"
    fi
fi

if [ ! -d "$THEME_DIR/$target" ]; then
    echo "Theme '$target' not found in $THEME_DIR!" >&2
    exit 1
fi

# Apply theme files
cp -f "$THEME_DIR/$target/config.jsonc" "$HOME/.config/waybar/config.jsonc"
cp -f "$THEME_DIR/$target/style.css" "$HOME/.config/waybar/style.css"
echo "$target" > "$ACTIVE_THEME_FILE"

# Regenerate battery SVG with new theme colors
"$HOME/.config/waybar/scripts/battery-svg.py" >/dev/null 2>&1

# Reload Waybar
killall -SIGUSR2 waybar

# Notification
if [ "$target" = "macos" ]; then
    notify-send -a "Waybar" -i preference-desktop-theme "Waybar Theme" "Switched to macOS Style (Light)"
else
    notify-send -a "Waybar" -i preference-desktop-theme "Waybar Theme" "Switched to Default Theme (Dark)"
fi
