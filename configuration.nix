# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."luks-5aa856f6-8eec-405e-8e50-be9fdd767f97".device = "/dev/disk/by-uuid/5aa856f6-8eec-405e-8e50-be9fdd767f97";
	networking.hostName = "nyaxos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
		networking.networkmanager.enable = true;

# Set your time zone.
	time.timeZone = "America/Sao_Paulo";

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pt_BR.UTF-8";
		LC_IDENTIFICATION = "pt_BR.UTF-8";
		LC_MEASUREMENT = "pt_BR.UTF-8";
		LC_MONETARY = "pt_BR.UTF-8";
		LC_NAME = "pt_BR.UTF-8";
		LC_NUMERIC = "pt_BR.UTF-8";
		LC_PAPER = "pt_BR.UTF-8";
		LC_TELEPHONE = "pt_BR.UTF-8";
		LC_TIME = "pt_BR.UTF-8";
	};

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "br";
		variant = "nodeadkeys";
	};

# Configure console keymap
	console.keyMap = "br-abnt2";

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.mathy = {
		isNormalUser = true;
		description = "mathy";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
	};

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
		hyprshot # 🪟 Hyprland & Wayland
			waybar
			hyprlock
			hyprpaper
			hyprpicker
			brightnessctl
			pamixer
			playerctl

			sbctl # 🛠️ Componentes Essenciais do Sistema
			nvtopPackages.full
			dunst
			grim
			slurp
#uwsm
			bluez
			bluez-tools
			zenity
			killall
#pipewire
			libsecret
			fuse2
			polkit_gnome
			zenity
			vim # 🧠 Desenvolvimento e Ferramentas de Programação
			neovim
			git
			gh
			lazydocker
			docker-client
			docker-compose
			vscode
			gcc
			nodejs_22
			tmux
			zoxide
			fzf
			bat
			stow

			kitty # 💻 Ambiente de Desktop / Sistema Gráfico
			rofi
#kdePackages.dolphin
			nautilus
			nemo
			nwg-look
#gnome-characters
			blueman
			obs-studio
			swaynotificationcenter
			hypridle
			hyprpaper
			hyprpicker
			colloid-gtk-theme
			colloid-kde
			colloid-icon-theme

			vivaldi # 🌐 Navegadores e Comunicação
			brave
			firefox
			discord
			zoom-us
			tor-browser-bundle-bin

			pavucontrol # 🎵 Áudio e Multimídia
			pamixer
			playerctl
			spotify

			btop # ⚙️ Ferramentas do Sistema (Qualidade de vida)
			fastfetch
			starship
			asciiquarium
			emote
			wl-clipboard
			tree
			yazi
			unzip
			cliphist
			power-profiles-daemon
			pkgs.gnomeExtensions.system-monitor
			
			baobab # 🗂️ Gerenciadores de Arquivos

			steam # 🎮 Jogos e Entretenimento
			heroic

			krita # 📝 Produtividade
			libreoffice
			obsidian
			yt-dlp
			];

#-------
# My configurations
#-------

#programs.hyprland.enable = true;
	programs.waybar.enable = true;

# Bluetooth
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

# Virtualization
	virtualisation.docker = {
		enable = true;
	};
# Fonts
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      noto-fonts 
      noto-fonts-cjk-sans 
      noto-fonts-color-emoji 
      liberation_ttf

      # REPLACED: nerdfonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only  # Recommended for broad icon support
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Noto Sans Mono" "FiraCode Nerd Font" ]; # Note the space in the font name for fontconfig
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
# Habilitar PipeWire e compatibilidade PulseAudio
	services.pipewire = {
		enable = true;
		audio.enable = true;
		alsa.enable = true;
		pulse.enable = true;
		jack.enable = false;
	};

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
			localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

# List services that you want to enable:
#services.gnome.gnome-keyring.enable = true;
	programs.hyprland = {
		enable = true;
		withUWSM = true;
	};
	qt.enable = true;
	services.dbus.enable = true;

	services.flatpak.enable = true;

# KDE wallet (optional, if you want a keyring)
#programs.kwallet.enable = true;
#services.dbus.packages = [ pkgs.kwallet-pam ];

	systemd.tpm2.enable = false;

# Portal configuration
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-hyprland
			xdg-desktop-portal-gtk
		];
	};

	security.polkit.enable = true;
#-------

#Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
