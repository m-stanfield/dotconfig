{
  config,
  lib,
  pkgs,
  home,
  ...
}:
{

  home.packages = with pkgs; [
    btop-cuda
  ];

  home.file = {
    ".config/btop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/btop";
    };
  };

}
