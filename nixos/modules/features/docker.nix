{ config, lib, pkgs, ... }:

with lib;

{
  options.features.docker = {
    enable = mkEnableOption "Docker containerization platform";
  };

  config = mkIf config.features.docker.enable {
    virtualisation.docker.enable = true;
    users.users.${config.main-user.userName}.extraGroups = [ "docker" ];
  };
}
