# Gaming: Lutris, RetroArch, XIVLauncher
# Enabled via: features.gaming.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.gaming;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraLibraries =
          pkgs: with pkgs; [
            libadwaita
            gtk4
          ];
      })
      (retroarch.withCores (
        cores: with cores; [
          desmume
        ]
      ))
      xivlauncher
    ];
  };
}
