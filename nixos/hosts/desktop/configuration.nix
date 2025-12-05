# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme1n1";
  boot.loader.grub.useOSProber = true;

  systemd.tmpfiles.rules = [
    # Type Path        Mode    UID     GID     Age  Argument
    "d     /mnt/ssd    0755    1000    100     -    -"
  ];
  fileSystems."/mnt/ssd" =
    { device = "/dev/disk/by-uuid/1e447dce-19ff-4a88-a30c-8586c8f4bee3";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };

}
