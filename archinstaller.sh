#! /bin/bash

# exit on error
set -e

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
    ### Fonts
    nerd-fonts
    ### 💻 Ambiente de Desktop / Sistema Gráfico
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
    dolphin
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
    dunst
    grim
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    slurp
    uwsm
    xdg-desktop-portal-hyprland
    polkit
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

ask() {
    while true; do
        read -rp "$1 (y/n): " yn
	[[ -z "$yn" ]] && return 0
	case "$yn" in
	    [Yy]*) return 0 ;;
	    [Nn]*) return 1 ;;
	    *) echo "Please answer y or n." ;;
	esac
    done
}

echo "The code will ask for sudo privilege to rum pacman."
echo
if ask "Do you want to update the system package database?"; then
    sudo pacman -Syu --needed
else
    echo "Skipping system update."
fi
echo
echo
if ask "Do you want to stow the .config before downloading the packages?"; then
    sudo pacman -S stow --needed
    cd ~/my-nixos-setup
    stow --adopt backgrounds bashrc fastfetch files hypr kitty rofi starship waybar wofi
    cd ~/
else
    echo "Skipping stow."
fi
echo
echo
if ask "Do you want to install the packages?"; then
    echo
    echo "Installing packages..."
    for pkg in "${PACKAGES[@]}"; do
        echo
	echo "Installing: $pkg"
        sudo pacman -S --needed "$pkg" || true
	# --needed dosen't reinstall a package if it's alredy installed
    done
else
    echo "Skipping packages instalation."
fi
echo
echo
if ask "Do you want to install the programs from web?"; then
    echo
    echo "Opening page to download zoom"
    xdg-open "https://zoom.us/download?os=linux"
    echo
    echo "Download the file in /Download."
    echo
    echo "The pacman will download zoom_x86_64.pkg.tar.xz if it's there."
    sudo pacman -U --needed ~/Downloads/zoom_x86_64.pkg.tar.xz
else
    echo "Sckipping web packages instalation."
fi
echo
echo
echo "All done!"
echo
echo
echo

