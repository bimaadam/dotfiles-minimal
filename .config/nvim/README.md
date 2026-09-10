# ⚡ AstroNvim Configuration (Minimalist Monochrome)

Konfigurasi AstroNvim v4 yang disesuaikan dengan tema minimalis monokrom dotfiles.

- **Theme**: `slugbyte/lackluster.nvim` (`lackluster-night`)
- **Background**: Pure Pitch Black (`#000000`)
- **Installed Packs**: TypeScript/JS, Go, Rust, Java, HTML/CSS, PHP, SQL, YAML, Helm (K8s), Docker, Bash, Lua, Hyprlang.

---

## ⌨️ AstroNvim Cheatsheet & Keybindings

> **Leader Key** adalah tombol **`Space`** (Spasi).

### 1. Membuka Project & File
| Shortcut / Command | Deskripsi |
| :--- | :--- |
| `nvim .` | Membuka folder project saat ini (mirip `code .` di VS Code) |
| `nvim <nama_file>` | Membuka atau membuat file baru langsung |
| `<Space> + e` | Buka / tutup sidebar file explorer (**Neo-tree**) |
| `<Space> + f + f` | Cari file di project (**Find files**) |
| `<Space> + f + w` | Cari kata / teks di seluruh folder project (**Live grep**) |
| `<Space> + f + o` | Buka file yang baru saja dibuka (**Recent files**) |
| `<Space> + b + b` | Pilih buffer / tab file yang sedang aktif |

---

### 2. Dasar Mengetik & Simpan (Vim Modes)
| Tombol | Mode / Fungsi |
| :--- | :--- |
| `i` | **Insert Mode** (Mulai mengetik teks / kode) |
| `Esc` | Kembali ke **Normal Mode** (mode navigasi / shortcut) |
| `<Space> + w` *(atau `:w`)* | **Save** file yang sedang aktif |
| `:q` | Tutup file / jendela saat ini |
| `:qa` | Keluar dari Neovim |
| `u` | Undo (kembalikan perubahan) |
| `Ctrl + r` | Redo (ulangi perubahan) |

---

### 3. Window Splitting (Bagi Layar)
| Shortcut | Aksi |
| :--- | :--- |
| `\|` *(atau `:vsplit`)* | Split layar **vertikal** (kiri - kanan) |
| `-` *(atau `:split`)* | Split layar **horizontal** (atas - bawah) |
| `Ctrl + h / j / k / l` | Pindah kursor antar split window (kiri / bawah / atas / kanan) |

---

### 4. Git & Terminal Terintegrasi
| Shortcut | Aksi |
| :--- | :--- |
| `<Space> + g + g` *(atau `<Space> + t + l`)* | Buka UI Git interaktif (**Lazygit**) |
| `<Space> + t + f` | Buka popup floating terminal di dalam editor |
| `<Space> + t + h` | Buka terminal horizontal di bawah editor |

---

### 5. Coding, LSP & Formatter
| Shortcut | Aksi |
| :--- | :--- |
| `<Space> + l + f` | Format kode otomatis (**Prettier / Linter**) |
| `<Space> + l + r` | Rename variabel / fungsi di seluruh project |
| `<Space> + l + a` | Code actions / Quick fix |
| `gd` | Go to definition (loncat ke deklarasi fungsi/variabel) |
| `K` | Hover info (lihat tipe data / dokumentasi fungsi) |
| `[d` / `]d` | Loncat ke error / diagnostic sebelumnya / berikutnya |

---

### 6. Manajemen Paket & Plugin
| Shortcut | Aksi |
| :--- | :--- |
| `<Space> + p + m` | Buka **Mason** (install LSP, linter, formatter baru) |
| `<Space> + p + l` | Buka **Lazy** (update & kelola plugin) |
| `<Space> + p + c` | Buka **AstroCommunity** updater |
