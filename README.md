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
| `Super + A` | Toggle animations (Smooth Cinematic / Default) |
| `Super + F` | Toggle fullscreen |
| `Super + Space` | Toggle floating & center window |
| `Super + Shift + W` | Toggle Waybar |
| `Super + Tab` | Lock screen (`hyprlock`) |
| `Super + ` ` | Logout menu (`wlogout`) |
| `Super + 1, 2, 3..` | Switch workspaces |
| `Super + Shift + 1, 2..` | Move window to workspace |
| `Super + Mouse Wheel` | Zoom in / out |
| `Super + Delete` / `Print` | Fullscreen screenshot (save & clipboard) |
| `Delete` / `Super + Print` | Region screenshot (save & clipboard) |

---

## ⚡ AstroNvim (Code Editor) Cheatsheet

> Leader Key di AstroNvim adalah tombol **`Space`** (Spasi).

### 1. Buka Project & File
| Perintah / Shortcut | Aksi |
| :--- | :--- |
| `nvim .` | Buka folder project saat ini (mirip `code .`) |
| `nvim index.js` | Buka atau buat file baru langsung |
| `Space + e` | Buka / tutup sidebar file explorer (**Neo-tree**) |
| `Space + f + f` | Cari file di project (**Find files**) |
| `Space + f + w` | Cari teks/kata di seluruh project (**Live grep**) |
| `Space + f + o` | Buka file yang baru saja ditutup (**Recent files**) |

### 2. Dasar Ngetik & Simpan
| Tombol | Mode / Aksi |
| :--- | :--- |
| `i` | Masuk ke **Insert Mode** (mulai mengetik kode) |
| `Esc` | Kembali ke **Normal Mode** |
| `Space + w` *(atau `:w`)* | **Save** file yang sedang aktif |
| `:q` | Tutup file / jendela saat ini |
| `:qa` | Keluar dari Neovim |

### 3. Git & Terminal Terintegrasi
| Shortcut | Aksi |
| :--- | :--- |
| `Space + g + g` / `Space + t + l` | Buka UI Git interaktif (**Lazygit**) |
| `Space + t + f` | Buka floating terminal di dalam editor |

### 4. Coding & LSP (Auto-format & Navigasi)
| Shortcut | Aksi |
| :--- | :--- |
| `Space + l + f` | Format kode otomatis (**Prettier / Linter**) |
| `Space + l + r` | Rename variabel di seluruh project |
| `gd` | Go to definition (loncat ke deklarasi fungsi/variabel) |
| `K` | Hover info (lihat tipe data / dokumentasi fungsi) |
| `Space + p + m` | Buka **Mason** (install/update bahasa & LSP baru) |

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
