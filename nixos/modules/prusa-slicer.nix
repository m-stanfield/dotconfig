# Desktop: PrusaSlicer 3D printing
# Enabled via: features.desktop.prusaSlicer.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.desktop;
in
{
  config = lib.mkIf cfg.prusaSlicer.enable {
    environment.systemPackages = [ pkgs.prusa-slicer ];
  };
}
