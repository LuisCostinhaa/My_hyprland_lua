#!/usr/bin/env bash

# 1. Criar a estrutura de pastas necessária
mkdir -p ~/PKG/My-Projects/My_hyprland_lua/config
mkdir -p ~/PKG/My-Projects/My_hyprland_lua/sddm/Backgrounds

# 2. Copiar ficheiros de configuração do utilizador local
cp -r ~/.zshrc ~/PKG/My-Projects/My_hyprland_lua/
cp -r ~/.zshenv ~/PKG/My-Projects/My_hyprland_lua/
cp -r ~/.bashrc ~/PKG/My-Projects/My_hyprland_lua/
cp -r ~/Imagens/backgrounds ~/PKG/My-Projects/My_hyprland_lua/

# 3. Copiar ficheiros do sistema (com sudo, mas corrigindo o dono logo de seguida)
sudo cp -r /usr/local/share/fonts ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/sddm.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/pacman.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/makepkg.conf ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /etc/default/grub ~/PKG/My-Projects/My_hyprland_lua/
sudo cp -r /usr/share/sddm/themes/Sugar-Candy/Backgrounds/. ~/PKG/My-Projects/My_hyprland_lua/sddm/Backgrounds/
sudo cp -r /usr/share/sddm/themes/Sugar-Candy/theme.conf ~/PKG/My-Projects/My_hyprland_lua/sddm/

# 4. Copiar TODO o conteúdo de ~/.config (incluindo pastas ocultas de forma segura)
cp -r ~/.config/. ~/PKG/My-Projects/My_hyprland_lua/config/

# 5. Corrigir permissões de forma RECURSIVA (-R) usando a variável automática do utilizador atual
sudo chown -R "$USER":"$USER" ~/PKG/My-Projects/My_hyprland_lua
