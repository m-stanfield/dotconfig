# System packages and fonts
{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  environment.systemPackages = with pkgs; [
    psmisc
    starship
    slack
    filezilla
    file-roller
    p7zip
    sqlitebrowser
    nixfmt-tree
    calibre
    vlc
    audacity
    telegram-desktop
    signal-desktop
    qdirstat
    qalculate-qt
    kalker
    speedcrunch
    numbat
    pinta
    ffmpeg
    glances
    obsidian
    pulseaudio
    maim
    xclip
    systemctl-tui
    feh
    playerctl
    google-chrome
    vscode
    spotify
    discord
    stow
    cloc
    htop
    home-manager
    kitty
    catppuccin
    ripgrep
    unzip
    git
    vim
    wget
    lazygit
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
  ];
}
