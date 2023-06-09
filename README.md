# dotfiles-minimal

A clean, minimalist, and keyboard-driven Hyprland configuration for Arch Linux and EndeavourOS.

---

## 📁 Repository Structure

```text
.
├── .config/       # Main Linux configs (Hyprland, Waybar, Rofi, Kitty, Quickshell, etc.)
├── wallpapers/    # Minimalist wallpaper collection
├── cachyos/       # Alternative desktop & shell configurations for CachyOS
├── windows/       # Tiling window manager configuration for Windows (Komorebi/WHKD/YASB)
├── install.sh     # Automated installer script with backup support
└── packages.txt   # Required official & AUR packages
```

---

## ⌨️ Keybindings

> Full configuration available at [`.config/hypr/keybinds.lua`](.config/hypr/keybinds.lua)

| Keybind | Action |
| :--- | :--- |
| `Super + T` | Terminal (`kitty`) |
| `Super + Q` | Close active window |
| `Super + D` | Application launcher (`rofi`) |
| `Super + E` | File manager (`thunar`) |
| `Super + B` | Browser |
| `Super + W` | Wallpaper selector (`quickshell`) |
| `Super + V` | Clipboard history (`cliphist`) |
| `Super + O` | Switch opacity |
| `Super + F` | Toggle fullscreen |
| `Super + Space` | Toggle floating & center window |
| `Super + Shift + W` | Toggle Waybar |
| `Super + Tab` | Lock screen (`hyprlock`) |
| `Super + ` ` | Logout menu (`wlogout`) |
| `Super + 1, 2, 3..` | Switch workspaces |
| `Super + Shift + 1, 2..` | Move window to workspace |
| `Super + Mouse Wheel` | Zoom in / out |
| `Super + Delete` | Fullscreen screenshot (`grim`) |
| `Delete` | Region screenshot (`grim` + `slurp`) |

---

## 🚀 Quick Start

Ensure `git` is installed, then clone and run the installer:

```bash
git clone https://github.com/bimaadam/dotfiles-minimal.git
cd dotfiles-minimal
chmod +x install.sh
./install.sh
```

> **Note:** The installer automatically creates a timestamped backup of your existing `~/.config` under `~/.config-backups/` before applying any changes.
