#!/usr/bin/env bash
# Update Telegram theme with currently active desktop wallpaper

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER=""

# Detect active wallpaper from awww query
if command -v awww >/dev/null 2>&1; then
    WALLPAPER="$(awww query 2>/dev/null | grep -o 'image: .*' | head -n 1 | cut -d' ' -f2-)"
fi

# Fallback
if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    WALLPAPER="$HOME/Pictures/Wallpapers/07.jpg"
fi

if [[ ! -f "$WALLPAPER" ]]; then
    WALLPAPER="$REPO_DIR/wallpapers/07.jpg"
fi

echo "Using wallpaper: $WALLPAPER"

python3 - <<PY
import urllib.request
import zipfile
import shutil
import os

url = "https://raw.githubusercontent.com/catppuccin/telegram/main/src/mocha/desktop"
with urllib.request.urlopen(url) as resp:
    content = resp.read().decode("utf-8")

replacements = {
    "name: Catppuccin Mocha": "name: Monochrome Minimal",
    "shortname: ctp_mocha": "shortname: monochrome_minimal",
    "ctpBase: #1e1e2e;": "ctpBase: #0d0d0f;",
    "ctpBaseTransparent: #1e1e2ecc;": "ctpBaseTransparent: #0d0d0fcc;",
    "ctpBlue: #89b4fa;": "ctpBlue: #d4d4d8;",
    "ctpCrust: #11111b;": "ctpCrust: #070708;",
    "ctpCrustShadow: #11111b11;": "ctpCrustShadow: #07070811;",
    "ctpCrustTransparent: #11111bcc;": "ctpCrustTransparent: #070708cc;",
    "ctpFlamingo: #f2cdcd;": "ctpFlamingo: #a8a8b2;",
    "ctpGreen: #a6e3a1;": "ctpGreen: #ffffff;",
    "ctpLavender: #b4befe;": "ctpLavender: #d4d4d8;",
    "ctpMantle: #181825;": "ctpMantle: #0a0a0c;",
    "ctpMantleTransparent: #181825cc;": "ctpMantleTransparent: #0a0a0ccc;",
    "ctpMaroon: #eba0ac;": "ctpMaroon: #888892;",
    "ctpMauve: #cba6f7;": "ctpMauve: #cccccc;",
    "ctpOverlay0: #6c7086;": "ctpOverlay0: #45454d;",
    "ctpOverlay1: #7f849c;": "ctpOverlay1: #60606b;",
    "ctpOverlay1Transparent: #7f849ccc;": "ctpOverlay1Transparent: #60606bcc;",
    "ctpOverlay2: #9399b2;": "ctpOverlay2: #7e7e8c;",
    "ctpOverlay2Transparent: #9399b2cc;": "ctpOverlay2Transparent: #7e7e8ccc;",
    "ctpPeach: #fab387;": "ctpPeach: #9999a2;",
    "ctpPink: #f5c2e7;": "ctpPink: #b8b8c2;",
    "ctpRed: #f38ba8;": "ctpRed: #e06c75;",
    "ctpRosewater: #f5e0dc;": "ctpRosewater: #a0a0aa;",
    "ctpRosewaterTransparent: #f5e0dccc;": "ctpRosewaterTransparent: #a0a0aacc;",
    "ctpSapphire: #74c7ec;": "ctpSapphire: #c4c4cc;",
    "ctpSky: #89dceb;": "ctpSky: #b0b0bb;",
    "ctpSubtext0: #a6adc8;": "ctpSubtext0: #9999a6;",
    "ctpSubtext1: #bac2de;": "ctpSubtext1: #b8b8c4;",
    "ctpSurface0: #313244;": "ctpSurface0: #141416;",
    "ctpSurface0Transparent: #313244cc;": "ctpSurface0Transparent: #141416cc;",
    "ctpSurface1: #45475a;": "ctpSurface1: #1f1f23;",
    "ctpSurface1Transparent: #45475acc;": "ctpSurface1Transparent: #1f1f23cc;",
    "ctpSurface2: #585b70;": "ctpSurface2: #2b2b30;",
    "ctpSurface2Transparent: #585b70cc;": "ctpSurface2Transparent: #2b2b30cc;",
    "ctpTeal: #94e2d5;": "ctpTeal: #a0a0aa;",
    "ctpText: #cdd6f4;": "ctpText: #f4f4f5;",
    "ctpYellow: #f9e2af;": "ctpYellow: #e5c07b;",
    "ctpAccent: ctpGreen;": "ctpAccent: #ffffff;",
}

for k, v in replacements.items():
    content = content.replace(k, v)

lines = [l for l in content.splitlines() if not l.startswith("wallpaper:")]
palette_content = "\n".join(lines)

wallpaper_src = "$WALLPAPER"
theme_path = os.path.expanduser("~/monochrome.tdesktop-theme")

with zipfile.ZipFile(theme_path, "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("colors.tdesktop-theme", palette_content)
    z.write(wallpaper_src, "background.jpg")

shutil.copy(theme_path, "$REPO_DIR/monochrome.tdesktop-theme")
print("Theme updated successfully at: " + theme_path)
PY
