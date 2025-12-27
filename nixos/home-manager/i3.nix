{
  config,
  lib,
  pkgs,
  home,
  ...
}:
let
  i3ConfigFile = "${config.home.homeDirectory}/code/dotconfig/config/i3";
  i3StatusRustConfigFile = "${config.home.homeDirectory}/code/dotconfig/config/i3status-rust";
  i3StatusConfigFile = "${config.home.homeDirectory}/code/dotconfig/config/i3status";
in
{
  home.packages = with pkgs; [
    i3status-rust
    i3lock
    i3

  ];
  home.file."${config.home.homeDirectory}/.config/i3" = {
    source = config.lib.file.mkOutOfStoreSymlink i3ConfigFile;
  };
  home.file."${config.home.homeDirectory}/.config/i3status-rust" = {
    source = config.lib.file.mkOutOfStoreSymlink i3StatusRustConfigFile;
  };
  home.file."${config.home.homeDirectory}/.config/i3status" = {
    source = config.lib.file.mkOutOfStoreSymlink i3StatusConfigFile;
  };

}
