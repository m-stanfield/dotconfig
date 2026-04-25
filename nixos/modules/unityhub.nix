# Development: Unity Hub
# Enabled via: features.development.unity.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.unity.enable {
    environment.systemPackages = [ pkgs.unityhub ];
  };
}
