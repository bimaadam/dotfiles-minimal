#!/usr/bin/env bash

THEME_DIR="$HOME/.config/waybar/themes"
ACTIVE_THEME_FILE="$HOME/.config/waybar/current_theme"

# Read current theme
current="default"
if [ -f "$ACTIVE_THEME_FILE" ]; then
    current=$(cat "$ACTIVE_THEME_FILE" | tr -d '[:space:]')
fi

# Normalize current theme
case "$current" in
    "macos"|"macos-light"|"light")
        current="macos-light"
        ;;
    "macos-dark"|"dark")
        current="macos-dark"
        ;;
    *)
        current="default"
        ;;
esac

# Determine target theme
target="$1"
if [ -z "$target" ] || [ "$target" = "toggle" ]; then
    case "$current" in
        "default")
            target="macos-light"
            ;;
        "macos-light")
            target="macos-dark"
            ;;
        "macos-dark")
            target="default"
            ;;
        *)
            target="macos-light"
            ;;
    esac
else
    case "$target" in
        "macos"|"light")
            target="macos-light"
            ;;
        "dark")
            target="macos-dark"
            ;;
    esac
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
case "$target" in
    "macos-light")
        notify-send -a "Waybar" -i preference-desktop-theme "Waybar Theme" "Switched to macOS Light"
        ;;
    "macos-dark")
        notify-send -a "Waybar" -i preference-desktop-theme "Waybar Theme" "Switched to macOS Dark"
        ;;
    "default")
        notify-send -a "Waybar" -i preference-desktop-theme "Waybar Theme" "Switched to Default Dark (Pill)"
        ;;
esac
