
{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      (pkgs.tmuxPlugins.catppuccin.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "tmux";
         rev= "073ee54992c59fedcc29c1525a26f95691f0ae1f";
        sha256= "11gmvifq6lir48rar1n1zp085ss6x3h52aawjqyrhh1i1zlxzpdd";
        };
      }))
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"

      set -g @catppuccin_status_modules "directory user host session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}

