{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      catppuccin
    ];
    extraConfig = ''
      set -g @plugin 'tmux-plugins/sensible'
      set -g @plugin 'tmux-plugins/resurrect'
      set -g @plugin 'tmux-plugins/continuum'
      set -g @plugin 'catppuccin/tmux'

      # Set Catppuccin Mocha theme
      set -g @catppuccin_flavour 'mocha'
    '';
  };
}

