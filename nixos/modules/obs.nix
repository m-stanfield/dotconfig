# Desktop: OBS Studio
# Enabled via: features.desktop.obs.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.desktop;
in
{
  config = lib.mkIf cfg.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
  };
}
