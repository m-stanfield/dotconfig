{
  config,
  lib,
  pkgs,
  home,
  ...
}:
{
  home.packages = with pkgs; [
    i3status-rust
    i3lock
    i3

  ];

  home.file = {
    ".config/i3/config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/i3/config";
    };
  };

  home.file = {
    ".config/i3status-rust/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/i3status-rust/config.toml";
    };
  };

  home.file = {
    ".config/i3status/config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/i3status/config";
    };
  };

}
