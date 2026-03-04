# Development: Docker
# Enabled via: features.development.docker.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.docker.enable {
    virtualisation.docker.enable = true;
    users.users.matt.extraGroups = [ "docker" ];
  };
}
