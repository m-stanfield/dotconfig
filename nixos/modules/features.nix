# Central feature flags module
# Pattern: NixOS module options with mkEnableOption
# Each feature can be toggled per-host in hosts/<hostname>/configuration.nix
{ lib, config, ... }:

let
  cfg = config.features;
in
{
  options.features = {
    # Gaming
    gaming = {
      enable = lib.mkEnableOption "gaming support (Steam, Lutris, etc.)";
      steam.enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.gaming.enable;
        description = "Enable Steam";
      };
    };

    # Development
    development = {
      docker.enable = lib.mkEnableOption "Docker support";
      virtualbox.enable = lib.mkEnableOption "VirtualBox support";
    };

    # Desktop
    desktop = {
      obs.enable = lib.mkEnableOption "OBS Studio";
      libreoffice.enable = lib.mkEnableOption "LibreOffice";
      autorandr.enable = lib.mkEnableOption "autorandr multi-monitor support";
    };

    # Editors
    editors = {
      cursor.enable = lib.mkEnableOption "Cursor editor";
    };
  };

  # No config here - each feature module handles its own mkIf
}
