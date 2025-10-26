{ config, pkgs, lib, ... }:

{

  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.plugins =  [
   pkgs.hyprlandPlugins.hy3
  ];

    

  wayland.windowManager.hyprland.settings = {
     exec-once = [
      "waybar"
     ];
     "$mod" = "SUPER";
     "$left" = "j";
     "$down" = "k";
     "$up" = "l";
     "$right" = "semicolon";
     "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
     bind =
       [
         "$mod, F, exec, firefox"
         "$mod, t, exec, kitty"


        # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"



         ", Print, exec, grimblast copy area"
         
       ]
       ++ (
         # workspaces
         # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
         builtins.concatLists (builtins.genList (i:
             let ws = i + 1;
             in [
               "$mod, code:1${toString i}, workspace, ${toString ws}"
               "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
             ]
           )
           9)
       );
   };
}
