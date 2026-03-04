# Development: VirtualBox
# Enabled via: features.development.virtualbox.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "matt" ];
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.clipboard = true;
  };
}
