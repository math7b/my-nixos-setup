#! /bin/bash

# exit on error
set -e

echo "The code will ask for sudo privilege to rum pacman."
echo "press ENTER to continue"

read

echo "Updating system package database..."
sudo pacman -Syu

PACKAGES=(
    ### 🧠 Desenvolvimento e Ferramentas de Programação
    vim
    neovim
    git
    github-cli
    zoxide
    fzf
    bat
    stow
    lazydocker
    docker
    tmux
    tree
    ### 💻 Ambiente de Desktop / Sistema Gráfico
    nerd-fonts
    hyprland
    wayland
    kitty
    waybar
    rofi
    hyprshot
    hyprlock
    hyprpaper
    hyprpicker
    nwg-look
    ### 🌐 Navegadores e Comunicação
    vivaldi
    discord
    torbrowser-launcher
    ### 🎵 Áudio e Multimídia
    pavucontrol
    pamixer
    playerctl
    ### 🛠️ Componentes Essenciais do Sistema
    sbctl
    brightnessctl
    nvtop
    ### ⚙️ Ferramentas do Sistema (Qualidade de vida)
    btop
    fastfetch
    starship
    asciiquarium
    ### 🗂️ Gerenciadores de Arquivos
    baobab
    ### 📝 Produtividade
    krita
    yt-dlp
)

echo "Installing packages..."
for pkg in "${PACKAGES[@]}"; do
    echo "Installing: $pkg"
    sudo pacman -S --needed "$pkg"
done

# --needed dosen't reinstall a package if it's alredy installed

echo "Opening page to download zoom"
xdg-open "https://zoom.us/download?os=linux"

echo "Download the file in /Download."
echo "The pacman will download zoom_x86_64.pkg.tar.xz if it's there."
echo "then press ENTER to continue."

read

sudo pacman -U --needed ~/Downloads/zoom_x86_64.pkg.tar.xz

echo "All done!"

