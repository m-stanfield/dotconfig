{ config, lib, pkgs,home, ... }:
{
  home.packages = with pkgs; [
    i3status
    i3lock
    i3-gaps
  ];
  home.file = {
    ".config/i3/config".source = ./i3config;
    ".config/i3status/config".source = ./i3statusconfig;
  };


}

