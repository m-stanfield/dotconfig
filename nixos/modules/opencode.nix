
{ lib, config, pkgs, ... }:
let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.opencode.enable {
    environment.systemPackages = with pkgs; [
      opencode
    ];
  };
}
