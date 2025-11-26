#! /bin/bash

# exit on error
set -e

echo "The code will ask for sudo privilege to rum pacman."

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

echo
echo

if ask "Install web programs?"; then
  urls=(
    "https://zoom.us/download?os=linux"
    "https://nodejs.org/en/download"
    "https://www.winboat.app"
  )
  for url in "${urls[@]}"; do
    if ask "$url - Open?";  then
      xdg-open "$url" 
      echo "Press ENTER for next"
      read
    fi
  done
  #sudo pacman -U --needed ~/Downloads/zoom_x86_64.pkg.tar.xz
fi

echo
echo

if ask "Update the system package database?"; then
  sudo pacman -Syu --needed
fi

echo
echo

if ask "Stow the .config before downloading the packages?"; then
  sudo pacman -S stow --needed
  cd ~/my-nixos-setup
  stow backgrounds bashrc fastfetch files hypr kitty rofi starship waybar wofi
  cd ~/
fi

echo
echo

if ask "Clone the typrcraft's dotfile?"; then
  if [ -d "$HOME/dotfiles/" ]; then
    echo "Repository already exists. Pulling updates..."
    git -C $HOME/dotfiles pull
  else
    echo "Repository not found. Cloning..."
    git clone https://github.com/math7b/dotfiles.git
  fi
  cd ~/dotfiles
  stow nvim tmux
  cd ~/
fi

PACKAGES=(
  ### 🛠️ Componentes Essenciais do Sistema
  wayland
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
  bluez
  bluez-utils
  ### Fonts
  nerd-fonts
  JetBrainsMono
  FiraCode
  ttf-noto-nerd
  noto-fonts-emoji
  ttf-nerd-fonts-symbols
  ttf-jetbrains-mono-nerd
  ttf-iosevka-nerd
  noto-fonts
  ttf-dejavu
  ### 🧠 Desenvolvimento e Ferramentas de Programação
  vim
  neovim
  git
  github-cli
  lazydocker
  dockeri
  libreoffice-still
  docker
  docker-compose
  code
  ### 💻 Ambiente de Desktop / Sistema Gráfico
  kitty
  rofi
  dolphin
  obs-studio
  nwg-look
  gnome-characters
  blueman
  ### hypr family
  hyprland
  hyprshot
  waybar
  hyprlock
  hyprpaper
  hyprpicker
  ### 🌐 Navegadores e Comunicação
  vivaldi
  discord
  torbrowser-launcher
  ### 🎵 Áudio e Multimídia
  pavucontrol
  pamixer
  playerctl
  ### ⚙️ Ferramentas do Sistema (Qualidade de vida)
  btop
  fastfetch
  starship
  asciiquarium
  zoxide
  tree
  fzf
  tmux
  yazi
  ### 🗂️ Gerenciadores de Arquivos
  bat
  stow
  baobab
  ### 📝 Produtividade
  krita
  yt-dlp
  ### For AppImage
  fuse2
)

if ask "Install the packages?"; then
  echo "Installing packages..."
  for pkg in "${PACKAGES[@]}"; do
    echo "Installing: $pkg"
    sudo pacman -S --needed "$pkg" || true
    # --needed dosen't reinstall a package if it's alredy installed
  done
fi

echo
echo

services=(
  bluetooth
  NetworkManager
)

if ask "Check some systemctl services?"; then
  for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      echo "$svc is running."
      if ask "$svc is not running, do you want to enable it?"; then
        echo " Starting $svc"
        sudo systemctl enable --now "$svc"
      fi
    fi
  done
fi

echo
echo

flathub=(
  "flatpak install flathub app.zen_browser.zen"
  "flatpak install flathub com.play0ad.zeroad"
  "flatpak install flathub org.diasurgical.DevilutionX"
)

if ask "Install flatpac stuffs?"; then
  if ask "Install flatpak?"; then
    sudo pacman -S flatpak --needed
    echo "flatpak need a reboot"
    if ask "Reboot now?"; then
      reboot
    fi
  fi
  if ask "Install flathub programs?"; then
    for flat in "${flathub[@]}"; do
      if ask "Install - $flat?"; then
        $flat
      fi
    done
  fi
fi

echo 
echo

echo "installing WinBoat"
./
echo "installing docker and docker-compose"
sudo pacman -S docker docker-compose
#echo "Adding user to docker group"
#sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo pacman -S freerdp




echo
echo

echo "All done!"

echo
echo
echo

