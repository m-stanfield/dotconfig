# Core programs configuration
{ config, ... }:

{
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # nix-ld allows running unpatched dynamic binaries
  programs.nix-ld = {
    enable = true;
  };
}
