# Development: Godot game engine
# Enabled via: features.development.godot.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.godot.enable {
    environment.systemPackages = [ pkgs.godot ];
  };
}
