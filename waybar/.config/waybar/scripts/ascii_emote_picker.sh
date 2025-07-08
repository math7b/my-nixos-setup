#!/usr/bin/env bash

choice=$(wofi --dmenu --prompt "Emote:" < ~/.config/waybar/ascii-emotes.txt)
[ -n "$choice" ] && wl-copy "$choice"

