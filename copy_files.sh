#!/usr/bin/env bash

# Sair imediatamente se algum comando falhar
set -e

# Definição do diretório de destino
DEST_DIR="$HOME/PKG/My-Projects/My_hyprland_lua"

echo "=== A iniciar o backup de configurações ==="

# 1. Criar a estrutura inicial de pastas necessária
mkdir -p "$DEST_DIR/config"
mkdir -p "$DEST_DIR/sddm/Backgrounds"

# 2. Copiar ficheiros e pastas de configuração do utilizador local
echo "-> A copiar ficheiros locais..."
for item in ".zshrc" ".zshenv" ".bashrc" "Imagens/backgrounds" ".var"; do
    if [ -e "$HOME/$item" ]; then
        cp -r "$HOME/$item" "$DEST_DIR/"
    else
        echo "Aviso: $HOME/$item não encontrado. Ignorado."
    fi
done

# 3. Copiar ficheiros do sistema (com sudo)
echo "-> A copiar ficheiros do sistema..."
sudo cp -r /usr/local/share/fonts "$DEST_DIR/" 2>/dev/null || echo "Aviso: fontes não encontradas."
sudo cp -r /etc/sddm.conf /etc/pacman.conf /etc/makepkg.conf /etc/default/grub "$DEST_DIR/" 2>/dev/null || true

# Copiar ficheiros do tema SDDM se existirem
if [ -d "/usr/share/sddm/themes/Sugar-Candy" ]; then
    sudo cp -r /usr/share/sddm/themes/Sugar-Candy/Backgrounds/. "$DEST_DIR/sddm/Backgrounds/"
    sudo cp -r /usr/share/sddm/themes/Sugar-Candy/theme.conf "$DEST_DIR/sddm/"
fi

# 4. Copiar conteúdo selecionado de ~/.config
echo "-> A copiar configurações do ~/.config..."

# Lista de pastas dentro de ~/.config
config_folders=(
    alacritty btop fastfetch gtk-3.0 hypr keepassxc kitty matugen 
    nwg-look pulse qt5ct qt6ct rofi scripts Thunar waybar xfce4 
    xsettingsd waypaper
)

for folder in "${config_folders[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        mkdir -p "$DEST_DIR/config/$folder"
        cp -r "$HOME/.config/$folder/." "$DEST_DIR/config/$folder/"
    fi
done

# Copiar ficheiros soltos do ~/.config
for file in "pavucontrol.ini" "user-dirs.locale"; do
    if [ -f "$HOME/.config/$file" ]; then
        cp "$HOME/.config/$file" "$DEST_DIR/config/"
    fi
done

# 5. Corrigir permissões de forma RECURSIVA de volta para o teu utilizador
echo "-> A corrigir permissões..."
sudo chown -R "$USER":"$USER" "$DEST_DIR"

echo "=== Backup concluído com sucesso! ==="
