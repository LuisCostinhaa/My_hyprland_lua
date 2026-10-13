#!/bin/bash

# Garante que o repositório Flathub está adicionado
echo "Verificando o repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org

echo "Iniciando a instalação das aplicações..."

# Lista de aplicações para instalar de forma automatizada
APPLICATIONS=(
    "net.code_industry.MasterPDFEditor"
    "org.libreoffice.LibreOffice"
    "com.stremio.Stremio"
    "org.gnome.Loupe"
    "com.sublimehq.SublimeText"
    "com.transmissionbt.Transmission"
    "io.github.pwr_solaar.solaar"
    "io.gitlab.librewolf-community"
    "io.missioncenter.MissionCenter"
    "org.gnome.Calculator"
    "org.gnome.Calendar"
    "org.gnome.clocks"
    "org.keepassxc.KeePassXC"
    "io.bassi.Amberol"
    "org.pulseaudio.pavucontrol"
)

for app in "${APPLICATIONS[@]}"; do
    echo "--------------------------------------------"
    echo "Instalando: $app"
    echo "--------------------------------------------"
    flatpak install -y flathub "$app"
done

echo "--------------------------------------------"
echo "Processo concluído com sucesso!"
