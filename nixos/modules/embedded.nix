{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.embedded.enable {
    services.udev.packages = with pkgs; [ 
      platformio-core.udev
      openocd
    ];
  };
}
