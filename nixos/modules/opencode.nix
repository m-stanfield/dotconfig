
{ lib, config, pkgs, inputs, pkgs-unstable, ... }:
let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.opencode.enable {
    environment.systemPackages = with pkgs-unstable; [
      opencode
    ];
  };
}
