#!/usr/bin/env bash

# Wayland Color Picker
if command -v hyprpicker >/dev/null 2>&1; then
    color=$(hyprpicker -a)
else
    # Fallback using slurp + grim + magick
    point=$(slurp -b 00000000 -p 2>/dev/null)
    [[ -z "$point" ]] && exit 0
    color=$(grim -g "$point" -t png - | magick - -format "#%[hex:u.p{0,0}]" info: 2>/dev/null)
fi

[[ -z "$color" ]] && exit 0

# Copy to clipboard
echo -n "$color" | wl-copy

# Generate preview swatch in /tmp for notification icon
preview_img="/tmp/picked_color_${color:1}.png"
magick -size 48x48 "xc:$color" "$preview_img" 2>/dev/null

notify-send -a "Color Picker" -i "$preview_img" "Color Copied" "<b>$color</b> copied to clipboard."
