#!/bin/sh

mkdir -p ~/PKG/My-Projects/My_hyprland_lua/config
mkdir -p ~/PKG/My-Projects/My_hyprland_lua/sddm/Backgrounds
cp -r ~/.zshrc ~/PKG/My-Projects/My_hyprland_lua/
cp -r ~/.zshenv ~/PKG/My-Projects/My_hyprland_lua/
cp -r ~/.bashrc ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /usr/local/share/fonts ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/sddm.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/pacman.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/makepkg.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/default/grub ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /usr/share/sddm/themes/Sugar-Candy/Backgrounds ~/PKG/My-Projects/My_hyprland_lua/sddm/Backgrounds
sudo cp -r /usr/share/sddm/themes/Sugar-Candy/theme.conf ~/PKG/My-Projects/My_hyprland_lua/sddm
sudo cp -r ~/Imagens/backgrounds ~/PKG/My-Projects/My_hyprland_lua/
cd ~/.config
cp -r ./* ~/PKG/My-Projects/My_hyprland_lua/config
cd ~/PKG/My-Projects/My_hyprland_lua
sudo chown vm:vm *

