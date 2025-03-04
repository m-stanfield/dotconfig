{ config, lib, pkgs,home, ... }:

let
  mod = "Mod4";
in 
{
  home.packages = with pkgs; [
    i3status
    i3lock
    i3-gaps
  ];

#in home.nix
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = "kitty";
      fonts = [
        "DejaVu Sans Mono:size=10"
        "FontAwesome:size=10"
        "JetBrains Mono:size=10"
      ];
      keybindings = lib.mkOptionDefault{
        "${mod}+Return" = "exec kitty";  
        "${mod}+space" = "exec rofi -show drun"; 
        "${mod}+Tab" = "exec rofi -show window";  
        "${mod}+Shift+D" = "exec rofi -show run"; 
        # Focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
      };
      modifier = mod;
      gaps = {
        inner = 10;
        outer = 5;
      };
    };
  };
}

