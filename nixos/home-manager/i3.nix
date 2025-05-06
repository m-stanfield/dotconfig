{ config, lib, pkgs,home, ... }:
{
  home.packages = with pkgs; [
    i3status-rust
    i3lock
    i3-gaps

  ];
  home.activation.linkI3Config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn "$HOME/code/dotconfig/config/i3/config" "$HOME/.config/i3/config"
  '';

  home.activation.linkI3StatusRustConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn "$HOME/code/dotconfig/config/i3status-rust/config.toml" "$HOME/.config/i3status-rust/config.toml"
  '';

  home.activation.linkI3StatusConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn "$HOME/code/dotconfig/config/i3status/config" "$HOME/.config/i3status/config"
  '';


}

