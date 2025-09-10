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

  boot.initrd.luks.devices."luks-5cdfe716-bde4-4af5-86a0-af99c693eec4".device = "/dev/disk/by-uuid/5cdfe716-bde4-4af5-86a0-af99c693eec4";
  networking.hostName = "nixos"; # Define your hostname.
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
    description = "Matheus Barth";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    ### 🧠 Desenvolvimento e Ferramentas de Programação
    vim
    neovim
    vscode
    code-cursor
    git
    gh
    zoxide
    fzf
    bat
    nodejs_22
    stow
    lazydocker
    docker-client
    tmux
    gcc
    ### 💻 Ambiente de Desktop / Sistema Gráfico
    hyprland
    wayland
    kitty
    waybar
    rofi
    hyprshot
    swaynotificationcenter
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    nwg-look
    colloid-gtk-theme
    colloid-kde
    colloid-icon-theme
    ### 🌐 Navegadores e Comunicação
    brave
    vivaldi
    discord
    zoom-us
    tor
    ### 🎵 Áudio e Multimídia
    pavucontrol
    pamixer
    playerctl
    spotify
    ### 🛠️ Componentes Essenciais do Sistema
    pipewire
    sbctl
    brightnessctl
    killall
    nvtopPackages.full
    blueman
    libsecret
    ### ⚙️ Ferramentas do Sistema (Qualidade de vida)
    btop
    fastfetch
    starship
    asciiquarium-transparent
    emote
    wl-clipboard
    obs-studio
    libreoffice
    power-profiles-daemon
    cliphist
    ### 🗂️ Gerenciadores de Arquivos
    nautilus
    nemo
    baobab
    ### 🎮 Jogos e Entretenimento
    steam
    heroic
    ### 📝 Produtividade
    obsidian
    krita
  ];

  #-------
  # My configurations
  #-------

  programs.hyprland.enable = true;
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
    fontconfig.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      roboto-mono

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu

      font-awesome
    ];
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
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;

  systemd.tpm2.enable = false;

  #-------

  # Some programs need SUID wrappers, can be configured further or are
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
