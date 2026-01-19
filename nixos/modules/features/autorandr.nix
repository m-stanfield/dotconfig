{ config, lib, pkgs, ... }:

with lib;

{
  options.features.autorandr = {
    enable = mkEnableOption "autorandr for automatic monitor configuration";

    profiles = mkOption {
      type = types.attrs;
      default = { };
      description = "Autorandr profiles configuration";
      example = literalExpression ''
        {
          "desk" = {
            fingerprint = {
              DP-0 = "...";
            };
            config = {
              DP-0 = {
                enable = true;
                mode = "1920x1080";
                position = "0x0";
                rate = "60.00";
              };
            };
          };
        }
      '';
    };
  };

  config = mkIf config.features.autorandr.enable {
    environment.systemPackages = with pkgs; [
      autorandr
    ];

    services.autorandr = {
      enable = true;
      profiles = config.features.autorandr.profiles;
    };
  };
}
