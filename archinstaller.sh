#! /bin/bash

# exit on error
set -e

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
  stow backgrounds bashrc fastfetch files hypr kitty rofi starship waybar wofi
  cd ~/
else
  echo "Skipping stow."
fi

echo
echo

if ask "Do you want to clone the fork of typrcraft's dotfile to import neovim and tmux .config?"; then
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
else
  echo "Skipping stow from typecraft."
fi

echo
echo

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

if ask "Do you want to check some systemctl services?"; then
  services=(
    bluetooth
    NetworkManager
  )
  echo
  for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      echo "$svc is running."
    else
      if ask "$svc is not running, do you want to enable it?"; then
        echo
        echo " Starting $svc"
        sudo systemctl enable --now "$svc"
      else
        echo "Skipping $svg service."
      fi
    fi
  done
else
  echo "Skipping services check."
fi

echo
echo

if ask "Do you want to install the programs from web?"; then
  urls=(
    "https://zoom.us/download?os=linux"
    "https://nodejs.org/en/download"
    "https://www.winboat.app"
  )
  for url in "${urls[@]}"; do
    echo
    if ask "$url Open?";  then
      echo
      echo "Openning page to download"
      xdg-open "$url"
      read
      echo 
      echo "Next."
    else
      echo "Skipping"
    fi
  done
  #sudo pacman -U --needed ~/Downloads/zoom_x86_64.pkg.tar.xz
else
  echo "Skipping web programs instalation."
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

