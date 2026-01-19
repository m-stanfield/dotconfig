{ config, lib, pkgs, ... }:

with lib;

{
  options.features.obs = {
    enable = mkEnableOption "OBS Studio for screen recording and streaming";
  };

  config = mkIf config.features.obs.enable {
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
