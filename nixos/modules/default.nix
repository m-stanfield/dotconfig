{
  # Import all feature modules
  imports = [
    # Features
    ./features/docker.nix
    ./features/virtualbox.nix
    ./features/desktop-i3.nix
    ./features/autorandr.nix

    # Programs
    ./programs/steam.nix
    ./programs/obs.nix
    ./programs/code-cursor.nix
    ./programs/libreoffice.nix
  ];
}
