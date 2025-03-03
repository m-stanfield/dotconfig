{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
in 
{

#in home.nix
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      fonts = [
        "DejaVu Sans Mono:size=10"
        "FontAwesome:size=10"
        "JetBrains Mono:size=10"
      ];
      keybindings = lib.mkOptionDefault{
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

