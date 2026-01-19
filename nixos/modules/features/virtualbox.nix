{ config, lib, pkgs, ... }:

with lib;

{
  options.features.virtualbox = {
    enable = mkEnableOption "VirtualBox virtualization";

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users that should have access to VirtualBox";
    };
  };

  config = mkIf config.features.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = config.features.virtualbox.users;
  };
}
