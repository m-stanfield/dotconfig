{ config, lib, pkgs, ... }:

with lib;

{
  options.features.steam = {
    enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf config.features.steam.enable {
    programs.steam.enable = true;
  };
}
