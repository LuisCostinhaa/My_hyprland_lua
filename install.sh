#!/usr/bin/env bash

# Terminar o script imediatamente se algum comando falhar
set -e

# Cores para o output
VERDE='\033[0;32m'
VERMELHO='\033[0;31m'
SEM_COR='\033[0m'

# Definir variável do host caso não esteja definida
MYHOSTNM="${MYHOSTNM:-$USER}"
SCRIPT_DIR="$(pwd)"

echo -e "${VERDE}[1/16] Configurando chaves e repositórios (Chaotic-AUR)...${SEM_COR}"
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Correção do pacman.conf (Adicionar o Chaotic-AUR antes de atualizar)
if [ -f pacman.conf ]; then
    sudo cp pacman.conf /etc/pacman.conf
fi

echo -e "${VERDE}[2/16] Atualizando o sistema...${SEM_COR}"
sudo pacman -Syu --noconfirm

echo -e "${VERDE}[3/16] Instalando dependências básicas e programas base...${SEM_COR}"
sudo pacman -S --needed --noconfirm base-devel git

echo -e "${VERDE}[4/16] Instalando o yay (Gerenciador AUR)...${SEM_COR}"
if ! command -v yay &> /dev/null; then
    cd /tmp || exit
    # Correção: Clonar do repositório correto do AUR, não do site principal
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR" || exit
    rm -rf /tmp/yay
else
    echo "Yay já está instalado."
fi

echo -e "${VERDE}[5/16] Instalando Base...${SEM_COR}"
yay -S --needed --noconfirm \
    amd-ucode xf86-video-amdgpu bash-completion mesa-utils mtools \
    bat dash lsd ntfs-3g gvfs 7zip gvfs-mtp opencl-amd xdg-user-dirs \
    polkit-gnome udiskie sg3_utils smartmontools efitools ntfsprogs

echo -e "${VERDE}[6/16] Instalando Hyprland...${SEM_COR}"
yay -S --needed --noconfirm \
    hyprland hyprpaper qt5-wayland qt6-wayland \
    xdg-desktop-portal-hyprland hyprshot xdg-desktop-portal-gtk \
    qt5ct qt6ct kvantum kvantum-qt5

echo -e "${VERDE}[7/16] Instalando File Manager...${SEM_COR}"
yay -S --needed --noconfirm \
    thunar thunar-archive-plugin thunar-volman tumbler

echo -e "${VERDE}[8/16] Instalando Zsh...${SEM_COR}"
yay -S --needed --noconfirm \
    zsh zsh-autosuggestions zsh-syntax-highlighting

echo -e "${VERDE}[9/16] Instalando Fonts...${SEM_COR}"
yay -S --needed --noconfirm ttf-jetbrains-mono-nerd

echo -e "${VERDE}[10/16] Instalando Audio...${SEM_COR}"
yay -S --needed --noconfirm \
    pavucontrol-gtk3 pamixer pipewire pipewire-pulse

echo -e "${VERDE}[11/16] Instalando Theming...${SEM_COR}"
yay -S --needed --noconfirm \
    papirus-folders-git papirus-icon-theme adw-gtk-theme \
    matugen-bin nwg-look colloid-icon-theme gtk-engine-murrine

echo -e "${VERDE}[12/16] Instalando Apps (Parte 1)...${SEM_COR}"
yay -S --needed --noconfirm \
    gnome-calculator gnome-disk-utility gnome-calendar gnome-clocks \
    xarchiver meld keepassxc alacritty kitty sublime-text-4 \
    fastfetch btop mission-center

echo -e "${VERDE}[13/16] Instalando Apps (Parte 2)...${SEM_COR}"
yay -S --needed --noconfirm \
    brave librewolf wl-color-picker \
    rofi waybar-git waypaper-git waybar-module-pacman-updates-git swaync awww

echo -e "${VERDE}[14/16] Instalando Display Manager...${SEM_COR}"
yay -S --needed --noconfirm sddm sddm-theme-sugar-candy-git
sudo systemctl enable sddm.service

echo -e "${VERDE}[15/16] Instalando Firewall...${SEM_COR}"
yay -S --needed --noconfirm ufw
sudo systemctl enable ufw.service
sudo systemctl start ufw.service
sudo ufw --force enable

echo -e "${VERDE}[16/16] Movendo arquivos de configuração e aplicando permissões...${SEM_COR}"
# Garantir que as pastas locais existem antes de atualizar
xdg-user-dirs-update

# Instalação segura do tema SDDM
if [ -d "sddm" ]; then
    sudo mkdir -p /usr/share/sddm/themes/Sugar-Candy
    sudo cp -r sddm/* /usr/share/sddm/themes/Sugar-Candy/
fi

# Cópia segura de recursos globais
[ -d "backgrounds" ] && mkdir -p ~/Imagens/backgrounds && cp -r backgrounds/* ~/Imagens/backgrounds
[ -d "fonts" ] && sudo mkdir -p /usr/local/share/fonts && sudo cp -r fonts/* /usr/local/share/fonts/
[ -f "sddm.conf" ] && sudo cp sddm.conf /etc/
[ -f "grub" ] && sudo cp grub /etc/default/grub
[ -f "makepkg.conf" ] && sudo cp makepkg.conf /etc/

# Cópia de dotfiles (.config e shell)
if [ -d "config" ]; then
    mkdir -p ~/.config
    cp -r config/* ~/.config/
fi

[ -f ".bashrc" ] && cp .bashrc ~
[ -f ".zshrc" ] && cp .zshrc ~
[ -f ".zshenv" ] && cp .zshenv ~

# Organização da Home do usuário
cd ~
mkdir -p ISOs PKG/My-Projects
if [ -d "My_hyprland_lua" ]; then
    mv My_hyprland_lua PKG/My-Projects/
fi

# Ajuste definitivo de permissões na Home do utilizador (remover sudo onde não deve)
chown -R "${USER}":"${USER}" "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config"

echo -e "${VERDE}Atualizando o Grub...${SEM_COR}"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "${VERDE}Configurando o ZSH como shell padrão...${SEM_COR}"
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "${MYHOSTNM}"

echo -e "${VERDE}Configuração concluída com sucesso!${SEM_COR}"
