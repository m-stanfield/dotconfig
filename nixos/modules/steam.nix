# Gaming: Steam
# Enabled via: features.gaming.steam.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.gaming;
in
{
  config = lib.mkIf cfg.steam.enable {
    programs.steam.enable = true;
  };
}
