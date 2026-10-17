#!/usr/bin/env bash
#
# ──────────────────────────────────────────────────────────────────────
#  BACKUP – “My‑Projects/My_hyprland_lua”
#
#  This script copies a curated set of user‑ and system‑wide
#  configuration files into $HOME/PKG/My‑Projects/My_hyprland_lua
#
#  Requirements:
#    •  Bash 4.0+ (or newer)
#    •  The executing user must be in the sudoers list
#  ──────────────────────────────────────────────────────────────────────
set -euo pipefail                     # Abort on any failure

# ──────────────────────────────────────────────────────────────────────
#  1. Destination path
# ──────────────────────────────────────────────────────────────────────
DEST_DIR="$HOME/PKG/My-Projects/My_hyprland_lua"

echo "===  Starting backup of configuration files  ==="

# ──────────────────────────────────────────────────────────────────────
#  2. Create the minimal directory skeleton
# ──────────────────────────────────────────────────────────────────────
mkdir -p \
    "$DEST_DIR/config" \
    "$DEST_DIR/sddm/Backgrounds"

# ──────────────────────────────────────────────────────────────────────
#  3. Copy user‑specific files
# ──────────────────────────────────────────────────────────────────────
echo "→  Copying your personal shell & misc files..."

declare -a USER_FILES=(
    ".zshrc"
    ".zshenv"
    ".bashrc"
    "Imagens/backgrounds"   # <-- your custom folder
    ".var"
)

for src in "${USER_FILES[@]}"; do
    [[ -e "$HOME/$src" ]] || { echo "⚠️  $HOME/$src not found – skipping"; continue; }
    cp -a "$HOME/$src" "$DEST_DIR/"
done

# ──────────────────────────────────────────────────────────────────────
#  4. Copy a handful of system‑wide configuration files
# ──────────────────────────────────────────────────────────────────────
echo "→  Copying system files (needs sudo) …"

# Ask for sudo just once – you’ll be prompted for your password only
# (unless you already have a recent sudo timestamp)
sudo -v

# List of files / directories we care about
declare -a SYS_FILES=(
    "/usr/local/share/fonts"
    "/etc/sddm.conf"
    "/etc/pacman.conf"
    "/etc/makepkg.conf"
    "/etc/default/grub"
)

for src in "${SYS_FILES[@]}"; do
    [[ -e "$src" ]] || { echo "⚠️  $src not found – skipping"; continue; }
    sudo cp -a "$src" "$DEST_DIR/"
done

# ──────────────────────────────────────────────────────────────────────
# 5. Copy the SDDM theme (if it exists)
# ──────────────────────────────────────────────────────────────────────
if [[ -d "/usr/share/sddm/themes/Sugar-Candy" ]]; then
    echo "→  Copying the Sugar‑Candy SDDM theme…"

    sudo cp -a "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/." \
        "$DEST_DIR/sddm/Backgrounds/"

    sudo cp -a "/usr/share/sddm/themes/Sugar-Candy/theme.conf" \
        "$DEST_DIR/sddm/"
fi

# ──────────────────────────────────────────────────────────────────────
# 6. Mirror the contents of ~/.config (only the folders you listed)
# ──────────────────────────────────────────────────────────────────────
echo "→  Copying selected folders from ~/.config …"

# The folders you actually want to back up – feel free to add/remove
declare -a CFG_FOLDERS=(
    "alacritty"
    "btop"
    "fastfetch"
    "gtk-3.0"
    "hypr"
    "keepassxc"
    "kitty"
    "matugen"
    "nwg-look"
    "pulse"
    "qt5ct"
    "qt6ct"
    "rofi"
    "scripts"
    "Thunar"
    "waybar"
    "xfce4"
    "xsettingsd"
    "waypaper"
)

# Create destination sub‑folders first (so `rsync` can use them)
for folder in "${CFG_FOLDERS[@]}"; do
    [[ -d "$HOME/.config/$folder" ]] || { echo "⚠️  $folder not found – skipping"; continue; }

    mkdir -p "$DEST_DIR/config/$folder"
    # Preserve everything – links, timestamps, permissions
    rsync -a "$HOME/.config/$folder/." "$DEST_DIR/config/$folder/"
done

# ──────────────────────────────────────────────────────────────────────
# 7. Copy any lone configuration files you listed explicitly
# ──────────────────────────────────────────────────────────────────────
echo "→  Copying any extra files from ~/.config …"

declare -a EXTRA_FILES=(
    "pavucontrol.ini"
    "user-dirs.locale"
)

for f in "${EXTRA_FILES[@]}"; do
    [[ -f "$HOME/.config/$f" ]] || { echo "⚠️  $f not found – skipping"; continue; }
    cp -a "$HOME/.config/$f" "$DEST_DIR/config/"
done

# ──────────────────────────────────────────────────────────────────────
# 8. Restore the ownership to your user (no more root:root files!)
# ──────────────────────────────────────────────────────────────────────
echo "→  Fixing ownership / permissions…"

# Recursively change back to your own user – useful if you copied anything as root
sudo chown -R "$USER:$USER" "$DEST_DIR"

# ──────────────────────────────────────────────────────────────────────
echo "===  Backup finished – enjoy!  ==="

# If you want the script to be reusable, you can drop it into
# ~/.local/bin and add an alias like
#   alias backup-hyprland='~/path/to/this/script.sh'
#
# ──────────────────────────────────────────────────────────────────────
