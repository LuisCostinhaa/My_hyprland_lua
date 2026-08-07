#!/bin/sh

######### yay #####
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
sudo rm -r yay

######### Chaotic-Aur #####
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo cp -r pacman.conf /etc
yay -Sy

######### Base #####
yay -Sy --noconfirm --needed \
base-devel amd-ucode xf86-video-amdgpu bash-completion mesa-utils mtools \
bat dash lsd ntfs-3g gvfs 7zip gvfs-mtp opencl-amd xdg-user-dirs \
polkit-gnome udiskie sg3_utils smartmontools efitools

######### Hyprland #####
yay -Sy --noconfirm --needed \
hyprland hyprpaper hyprland-qtutils qt5-wayland qt6-wayland \
xdg-desktop-portal-hyprland hyprshot xdg-desktop-portal-gtk \
qt5ct qt6ct kvantum kvantum-qt5

######### File Manager #####
yay -Sy --noconfirm --needed \
thunar thunar-archive-plugin thunar-volman tumbler

######### Zsh #####
yay -Sy --noconfirm --needed \
zsh zsh-autosuggestions zsh-syntax-highlighting

######### Fonts #####
yay -Sy --noconfirm --needed ttf-jetbrains-mono-nerd 
#ttf-joypixels ttf-fira-code ttf-font-awesome \
#noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

######### Audio #####
yay -Sy --noconfirm --needed \
pavucontrol-gtk3 pamixer pipewire pipewire-pulse

######### Theming #####
yay -Syu --noconfirm --needed \
papirus-folders-git papirus-icon-theme adw-gtk-theme \
matugen-bin nwg-look colloid-icon-theme gtk-engine-murrine

######### Apps #####
yay -Sy --noconfirm --needed \
gnome-calculator gnome-disk-utility gnome-calendar gnome-clocks \
xarchiver meld keepassxc ristretto parole mpv \
alacritty kitty sublime-text-4 masterpdfeditor libreoffice-fresh-pt \
fastfetch btop mission-center

yay -Sy --noconfirm --needed \
darktable-git \
brave librewolf \
wl-color-picker \
rofi waybar-git waypaper-git waybar-module-pacman-updates-git swaync awww \
android-file-transfer

######### Display Manager #####
yay -Sy --noconfirm --needed sddm sddm-theme-sugar-candy-git
sudo systemctl enable sddm.service

######### Firewall #####
yay -Sy --noconfirm --needed ufw
sudo ufw enable
sudo systemctl enable ufw.service

######### Setings #####
xdg-user-dirs-update
cd sddm
sudo cp -r ./* /usr/share/sddm/themes/Sugar-Candy
cd ..
sudo cp -r backgrounds ~/Imagens/
#cd backgrounds
#sudo mkdir /usr/share/backgrounds/
#sudo cp -r grub.png /usr/share/backgrounds/
#cd ..
sudo cp -r fonts /usr/local/share
sudo cp -r sddm.conf /etc/
sudo cp -r grub /etc/default
sudo cp -r makepkg.conf /etc
cd config || exit
sudo cp -r ./* ~/.config
#sudo cp -r /usr/share/themes/adw-gtk3-dark/gtk-4.0 ~/.config
cd ..
sudo cp .bashrc ~
sudo cp .zshrc ~
sudo cp .zshenv ~

######### Chown #####
cd || exit
mkdir -p ISOs PKG/My-Projects
sudo mv My_hyprland_lua PKG/My-Projects
sudo chown -R "${USER}":"${USER}" .bashrc
sudo chown -R "${USER}":"${USER}" .zshrc
sudo chown -R "${USER}":"${USER}" .config

########## Update Grub #####
sudo grub-mkconfig -o /boot/grub/grub.cfg

####################	ZSH		####################
sudo chsh -s /bin/zsh root
chsh -s /bin/zsh ${MYHOSTNM}

####################	Desempenho	####################
#yay -Sy --noconfirm --needed auto-cpufreq 

#sudo auto-cpufreq --install
#sudo auto-cpufreq --turbo auto
