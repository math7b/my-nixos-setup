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

flathub=(
  "flatpak install flathub app.zen_browser.zen"
  "flatpak install flathub com.github.tchx84.Flatseal"
  "flatpak install flathub it.mijorus.smile"
)

if ask "Install flatpac stuffs?"; then
  if ! flatpak --version >/dev/null 2>&1; then
    if ask "Install flatpak?"; then
      sudo pacman -S flatpak --needed
      echo "flatpak need a reboot"
      if ask "Reboot now?"; then
        reboot
      fi
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

if ask "Update the system package database?"; then
  sudo pacman -Syu --needed
fi

echo
echo

if ask "Stow some .config folders?"; then
  sudo pacman -S stow --needed
  if ask "Clone the math7b's dotfile?"; then
    cd ~/my-nixos-setup
    stow backgrounds archinstaller bashrc fastfetch files hypr kitty rofi starship waybar wofi
    cd ~/
  fi
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
fi

echo
echo

PACKAGES=(
  wayland # 🛠️ Componentes Essenciais do Sistema
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
  nerd-fonts # Fonts
  JetBrainsMono
  FiraCode
  ttf-noto-nerd
  noto-fonts-emoji
  ttf-nerd-fonts-symbols
  ttf-jetbrains-mono-nerd
  ttf-iosevka-nerd
  noto-fonts
  ttf-dejavu
  vim # 🧠 Desenvolvimento e Ferramentas de Programação
  neovim
  git
  github-cli
  lazydocker
  libreoffice-still
  docker
  docker-compose
  code
  kitty # 💻 Ambiente de Desktop / Sistema Gráfico
  rofi
  dolphin
  obs-studio
  nwg-look
  gnome-characters
  blueman
  hyprland # hypr family
  hyprshot
  waybar
  hyprlock
  hyprpaper
  hyprpicker
  vivaldi # 🌐 Navegadores e Comunicação
  discord
  torbrowser-launcher
  pavucontrol # 🎵 Áudio e Multimídia
  pamixer
  playerctl
  btop # ⚙️ Ferramentas do Sistema (Qualidade de vida)
  fastfetch
  starship
  asciiquarium
  zoxide
  tree
  fzf
  tmux
  yazi
  unzip
  bat # 🗂️ Gerenciadores de Arquivos
  stow
  baobab
  krita # 📝 Produtividade
  yt-dlp
  fuse2 # For AppImage
)

if ask "Install the packages?"; then
  echo "Installing packages..."
  for pkg in "${PACKAGES[@]}"; do
    echo
    echo "Installing: $pkg"
    sudo pacman -S --needed --noconfirm "$pkg" || true
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
    else
      if ask "$svc is not running, do you want to enable it?"; then
        echo " Starting $svc"
        sudo systemctl enable --now "$svc"
      fi
    fi
  done
fi

echo 
echo

if ask "Install WinBoat?"; then
  echo "Openning..."
  xdg-open https://www.winboat.app
  READ

  echo "installing dependencies for WinBoat"
  sudo pacman -S docker docker-compose
  sudo usermod -aG docker $USER
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
  sudo pacman -S freerdp
fi

if ask "Start WinBoat?"; then
  cd ~/Downloads
	./appimage-*
	cd ~/
fi

echo
echo

echo "finished"

