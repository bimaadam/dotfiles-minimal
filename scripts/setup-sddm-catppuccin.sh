#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Jalankan script ini dengan sudo: sudo ~/apply-catppuccin-sddm.sh"
  exit 1
fi

TMP_DIR="/tmp/catppuccin-mocha-themes"
if [ ! -d "$TMP_DIR" ]; then
  echo "Mengunduh tema Catppuccin Mocha dari GitHub..."
  mkdir -p "$TMP_DIR"
  for flavor in mauve lavender blue peach sapphire; do
    curl -sL "https://github.com/catppuccin/sddm/releases/download/v1.1.2/catppuccin-mocha-${flavor}-sddm.zip" -o "/tmp/${flavor}.zip"
    unzip -q -o "/tmp/${flavor}.zip" -d "$TMP_DIR"
    rm -f "/tmp/${flavor}.zip"
  done
fi

echo "Memasang tema Catppuccin Mocha ke /usr/share/sddm/themes/..."
mkdir -p /usr/share/sddm/themes/
cp -r "$TMP_DIR"/* /usr/share/sddm/themes/

mkdir -p /etc/sddm.conf.d
cat << 'CONF' > /etc/sddm.conf.d/theme.conf
[Theme]
Current=catppuccin-mocha-mauve
CONF

echo "Tema SDDM berhasil diset ke: catppuccin-mocha-mauve!"
echo "Bisa ditest dengan: sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/catppuccin-mocha-mauve"
