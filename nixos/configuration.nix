# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Core modules
    ./modules/features.nix
    ./modules/main-user.nix
    ./modules/audio.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/printing.nix
    ./modules/ssh.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/services.nix

    # Feature modules (guarded by mkIf)
    ./modules/virtualbox.nix
    ./modules/obs.nix
    ./modules/autorandr.nix
    ./modules/steam.nix
    ./modules/cursor.nix
    ./modules/libreoffice.nix
    ./modules/docker.nix
    ./modules/opencode.nix
    ./modules/llama.nix
    ./modules/gaming-packages.nix
    ./modules/unityhub.nix
    ./modules/godot.nix
    ./modules/prusa-slicer.nix
    ./modules/embedded.nix

    # Home-manager
    inputs.home-manager.nixosModules.default
  ];

  # Enable unfree software
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Main user configuration
  main-user.enable = true;
  main-user.userName = "matt";

  # Home-manager configuration
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users = {
      "matt" = import ./home-manager/home.nix;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
