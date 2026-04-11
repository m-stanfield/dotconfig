# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable features for ROG laptop (gaming laptop config)
  features = {
    gaming.enable = true;
    development.docker.enable = true;
    desktop = {
      obs.enable = true;
      libreoffice.enable = true;
      autorandr.enable = true;
    };
    editors.cursor.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
