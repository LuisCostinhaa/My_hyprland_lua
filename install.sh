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

echo -e "${VERDE}[1/15] Configurando chaves e repositórios (Chaotic-AUR)...${SEM_COR}"
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Correção do pacman.conf (Adicionar o Chaotic-AUR antes de atualizar)
if [ -f pacman.conf ]; then
    sudo cp pacman.conf /etc/pacman.conf
fi

echo -e "${VERDE}[2/15] Atualizando o sistema...${SEM_COR}"
sudo pacman -Syu --noconfirm

echo -e "${VERDE}[3/15] Instalando dependências básicas e programas base...${SEM_COR}"
sudo pacman -Syyyu --needed --noconfirm base-devel git

echo -e "${VERDE}[4/15] Instalando o yay (Gerenciador AUR)...${SEM_COR}"
if ! command -v yay &> /dev/null; then
    cd /tmp || exit
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR" || exit
    rm -rf /tmp/yay
else
    echo "Yay já está instalado."
fi

echo -e "${VERDE}[5/15] Instalando Base...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    bash-completion mtools linux-headers nano rsync \
    dash lsd ntfs-3g gvfs 7zip jq unzip gvfs-mtp xdg-user-dirs swaync \
    polkit-gnome udiskie sg3_utils smartmontools efitools ntfsprogs 

echo -e "${VERDE}[6/15] Instalando AUR...${SEM_COR}"
yay -S --needed --noconfirm nvidia-dkms nvidia-utils nvidia-settings opencl-nvidia lib32-nvidia-utils \
    matugen-bin waybar papirus-folders waypaper-git \
    cuda cudnn darktable-git

echo -e "${VERDE}[7/15] Instalando Hyprland...${SEM_COR}"
sudo pacman  -S --needed --noconfirm \
    hyprland qt5-wayland qt6-wayland xdg-desktop-portal-hyprland \
    hyprshot xdg-desktop-portal-gtk qt5ct qt6ct hyprpicker fcitx5-gtk fcitx5-qt

echo -e "${VERDE}[8/15] Instalando File Manager...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer 

echo -e "${VERDE}[9/15] Instalando Zsh...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    zsh zsh-autosuggestions zsh-syntax-highlighting 

echo -e "${VERDE}[10/15] Instalando Fonts...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-dejavu ttf-liberation terminus-font

echo -e "${VERDE}[11/15] Instalando Audio...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    pamixer pipewire pipewire-pulse alsa-utils

echo -e "${VERDE}[12/15] Instalando Theming...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    adw-gtk-theme nwg-look papirus-icon-theme

echo -e "${VERDE}[13/15] Instalando Apps (Parte 1)...${SEM_COR}"
sudo pacman -S --needed --noconfirm \
    gnome-disk-utility xarchiver meld alacritty fastfetch ufw ly cmatrix \
    btop firefox keepassxc android-file-transfer flatpak rofi awww

echo -e "${VERDE}[14/15] Enable Service...${SEM_COR}"
sudo systemctl enable ly@tty1.service
sudo systemctl enable --now fstrim.timer
sudo systemctl enable ufw.service
sudo systemctl start ufw.service
sudo ufw --force enable

echo -e "${VERDE}[15/15] Movendo arquivos de configuração e aplicando permissões...${SEM_COR}"

    #########################   Atualizar pastas locais    ##############################
xdg-user-dirs-update

    #########################   Cópia segura de recursos globais   ##############################
[ -d "backgrounds" ] && mkdir -p ~/Imagens/backgrounds && cp -r backgrounds/* ~/Imagens/backgrounds
[ -d "fonts" ] && sudo mkdir -p /usr/local/share/fonts && sudo cp -r fonts/* /usr/local/share/fonts/
[ -d "var" ] && sudo mkdir -p ~/.var && sudo cp -r var/* ~/.var
[ -d "ly" ] && sudo mkdir -p ~/etc/ly && sudo cp -r ly/* /etc/ly
[ -f "makepkg.conf" ] && sudo cp makepkg.conf /etc/
[ -f "vconsole.conf" ] && sudo cp vconsole.conf /etc/
[ -f "grub" ] && sudo cp grub /etc/default/

    #########################   Cópia de dotfiles (.config e shell)   ##############################
if [ -d "config" ]; then
    mkdir -p ~/.config
    cp -r config/* ~/.config/
fi

[ -f ".zshrc" ] && cp .zshrc ~
[ -f ".zshenv" ] && cp .zshenv ~

    #########################   Organização da Home do usuário   ##############################
cd ~
mkdir -p ISOs PKG/My-Projects
if [ -d "My_hyprland_lua" ]; then
    mv My_hyprland_lua PKG/My-Projects/
fi

# Ajuste definitivo de permissões na Home do utilizador (remover sudo onde não deve)
sudo chown -R "${USER}":"${USER}" "$HOME/.zshrc" "$HOME/.config" "$HOME/.var"

    #########################   GRUB   ##############################
echo -e "${VERDE}Atualizando o Grub...${SEM_COR}"
sudo grub-mkconfig -o /boot/grub/grub.cfg

    #########################   ZSH   ##############################
echo -e "${VERDE}Configurando o ZSH como shell padrão...${SEM_COR}"
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh $USER

    #########################   Fim   ##############################
echo -e "${VERDE}Configuração concluída com sucesso!${SEM_COR}"
