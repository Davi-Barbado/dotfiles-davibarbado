#!/bin/bash

# Configurações de segurança: para o script se algo falhar
set -e

DOTFILES="$HOME/dotfiles"

echo "Iniciando a automação do seu ambiente..."

# 1. Atualizar e instalar pacotes essenciais
echo "Instalando dependências..."
sudo pacman -Syu --noconfirm --needed kitty rofi nemo nemo-fileroller nwg-look wget tar scrot picom autotiling fastfetch feh git base-devel
yay -S --noconfirm --needed brave-bin volctl

# 2. Remover o que não queremos
sudo pacman -Rs xterm --noconfirm

# 3. Criar diretórios necessários
echo "Criando diretórios..."
mkdir -p ~/.icons ~/.themes ~/.config/rofi ~/.config/i3 ~/.config/i3status ~/.config/kitty ~/.config/picom

# 4. Instalar Temas e Cursores
echo "Configurando temas e cursores..."
if [ ! -f "Nordic-darker-v40.tar.xz" ]; then
    wget -q https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker-v40.tar.xz
    tar -xf Nordic-darker-v40.tar.xz
    mv Nordic-darker-v40 ~/.themes/
fi

if [ -d "$DOTFILES/Twilight-cursors" ]; then
    cp -r "$DOTFILES/Twilight-cursors" ~/.icons/
fi

# 5. Instalar rofi-power-menu
echo "Instalando rofi-power-menu..."
cd /tmp
git clone https://github.com/jluttine/rofi-power-menu.git
cd rofi-power-menu
sudo cp rofi-power-menu /usr/local/bin/
cd ..
rm -rf rofi-power-menu

# 6. Aplicar Dotfiles
if [ -d "$DOTFILES" ]; then
    echo "Copiando dotfiles..."
    cp "$DOTFILES/i3/config" ~/.config/i3/
    cp "$DOTFILES/i3status/config" ~/.config/i3status/
    cp "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/
    cp "$DOTFILES/picom/picom.conf" ~/.config/picom/
    cp "$DOTFILES/rofi/theme.rasi" ~/.config/rofi/
fi

# 7. Configurações de Sistema
echo "Aplicando configurações de sistema..."
sudo cp "$DOTFILES/slick-greeter.conf" /etc/lightdm/
sudo mkdir -p /usr/share/backgrounds
sudo cp "$DOTFILES/wallpapers/11356502.png" /usr/share/backgrounds/

# 8. Finalização
feh --bg-fill /usr/share/backgrounds/11356502.png

echo "Setup concluído com sucesso! Agora é só reiniciar o i3."
