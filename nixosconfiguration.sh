#!/usr/bin/env bash

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

if ask "Install flatpac stuffs?"; then
  flathub=(
    "flatpak install flathub com.github.tchx84.Flatseal"
    "flatpak install flathub app.zen_browser.zen"
    #I was having problens to mack zen install files in ~/Downloads
    #After this comand it worked even if reseting the configs in flatseal
    #flatpak override --user --filesystem=xdg-download app.zen_browser.zen
    "flatpak install flathub it.mijorus.smile"
    "flatpak install flathub com.heroicgameslauncher.hgl"
  )
  echo "Will install flatpak if not already installed"
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  echo "flatpak need a reboot"
  if ask "Reboot now?"; then
    reboot
  fi
  if ask "Install flathub programs?"; then
    for flat in "${flathub[@]}"; do
      if ask "Install - $flat?"; then
        $flat
      fi
    done
  fi
fi