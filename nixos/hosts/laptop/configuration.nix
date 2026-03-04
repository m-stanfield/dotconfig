# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable features for laptop (minimal config - customize as needed)
  features = {
    gaming.enable = false;
    development.docker.enable = true;
    desktop = {
      libreoffice.enable = true;
      autorandr.enable = true;
    };
    editors.cursor.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
