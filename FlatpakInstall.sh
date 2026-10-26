#!/usr/bin/env bash
# ------------------------------------------------------------
# Script de instalação automática de aplicativos Flatpak
# ------------------------------------------------------------
# O script:
#  1. Verifica e adiciona o repositório Flathub (se ainda não existir).
#  2. Instala uma lista pré‑definida de aplicativos.
#
# Licença: CC0 (public domain)
# ------------------------------------------------------------

# Mantém o script em modo “fail‑fast” – caso algo dê errado, ele encerra imediatamente.
set -euo pipefail

echo "Verificando o repositório Flathub..."

# Adiciona o repositório Flathub apenas se ele ainda não existir
flatpak remote-add --if-not-exists flathub https://flathub.org

echo "Iniciando a instalação das aplicações..."

# --------------------------------------------
# Lista de aplicações a serem instaladas (via Flatpak)
# --------------------------------------------
APPLICATIONS=(
    "net.code_industry.MasterPDFEditor"
    "org.libreoffice.LibreOffice"
    "com.stremio.Stremio"
    "org.gnome.Loupe"
    "com.sublimehq.SublimeText"
    "com.transmissionbt.Transmission"
    "io.missioncenter.MissionCenter"
    "org.gnome.Calculator"
    "org.gnome.Calendar"
    "org.gnome.clocks"
    "io.bassi.Amberol"
    "org.pulseaudio.pavucontrol"
    "it.mijorus.gearlever"
    "com.brave.Browser"
)

# --------------------------------------------
# Instala cada aplicação
# --------------------------------------------
for app in "${APPLICATIONS[@]}"; do
    echo "--------------------------------------------"
    echo "Instalando: $app"
    echo "--------------------------------------------"
    flatpak install -y flathub "$app"
done

echo "--------------------------------------------"
echo "Processo concluído com sucesso!"
