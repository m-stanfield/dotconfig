# System packages and fonts
{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  environment.systemPackages = with pkgs; [
    (llama-cpp.override { cudaSupport = true; })
    ollama-cuda
    psmisc
    godot
    starship
    slack
    filezilla
    (retroarch.withCores (
      cores: with cores; [
        desmume
      ]
    ))
    file-roller
    prusa-slicer
    p7zip
    sqlitebrowser
    nixfmt-tree
    calibre
    vlc
    audacity
    telegram-desktop
    qdirstat
    qalculate-qt
    kalker
    (lutris.override {
      extraLibraries =
        pkgs: with pkgs; [
          libadwaita
          gtk4
        ];
    })
    speedcrunch
    numbat
    pinta
    ffmpeg
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
