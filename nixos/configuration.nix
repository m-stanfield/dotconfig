# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./virtual-box.nix
      ./obs.nix
      ./autorandr.nix
      ./main-user.nix
      ./steam.nix
      ./code-cursor.nix
      ./libreoffice.nix
      ./docker.nix
      inputs.home-manager.nixosModules.default
    ];
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    nvidiaPatches = true;
  };
  # enable unfree software
  nixpkgs.config = {
    allowUnfree = true;
  };
  
  # Enabling features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  main-user.enable = true;
  main-user.userName = "matt";
  programs.nix-ld = {
    enable = true;
  };

  #services.ssh-agent.enable = true;
  # programs.ssh.startAgent = true;



  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };



  services.gnome.gnome-keyring = {
    enable = true;

  };

  # Configure keymap in X11
  
  services = {
    blueman.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
  # services.xserver.libinput.enable = true;



  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  services.ratbagd.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    godot
    starship
    slack
    filezilla
    (retroarch.withCores (cores: with cores; [
      desmume
    ]))
    file-roller
    prusa-slicer
    p7zip
    sqlitebrowser
    calibre
    vlc
    telegram-desktop
    qdirstat
    qalculate-qt
    kalker
    (lutris.override {
      extraLibraries = pkgs: with pkgs; [
        libadwaita
        gtk4
      ];
    })
    speedcrunch
    numbat
    pinta    
    wofi
    xivlauncher
    glances
    obsidian
    pulseaudio
    maim
    xclip
    systemctl-tui
    feh
    playerctl 
    unityhub
    google-chrome
    vscode
    nvtopPackages.nvidia
    spotify
    discord
    stow
    cloc
    htop
    home-manager
    # tmux
    kitty
    catppuccin
    ripgrep
    unzip
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lazygit
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users = {
      "matt" = import ./home-manager/home.nix;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      PermitRootLogin = "prohibit-password";
    };

  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3000 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
