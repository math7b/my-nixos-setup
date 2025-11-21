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
  JetBrainsMono
  FiraCode
  ttf-noto-nerd
  noto-fonts-emoji
  ttf-nerd-fonts-symbols
  ttf-jetbrains-mono-nerd
  #    ttf-iosevka-nerd
  #    noto-fonts
  #    ttf-dejavu
  ### 🧠 Desenvolvimento e Ferramentas de Programação
  vim
  neovim
  git
  github-cli
  lazydocker
  dockeri
  libreoffice-still
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
)

if ask "Do you want to install the packages?"; then
  echo
  echo
  echo "Installing packages..."
  for pkg in "${PACKAGES[@]}"; do
    echo
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

if ask "Do ou want to check some systemctl services?"; then
  services=(
    bluetooth
    NetworkManager
  )
  for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      echo
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
  echo
  echo "Opening page to download zoom"
  xdg-open "https://zoom.us/download?os=linux"
  echo
  echo "Press enter to go on."
  read
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

