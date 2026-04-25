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
      opencode.enable = lib.mkEnableOption "Opencode support";
      docker.enable = lib.mkEnableOption "Docker support";
      virtualbox.enable = lib.mkEnableOption "VirtualBox support";
      unity.enable = lib.mkEnableOption "Unity Hub";
      godot.enable = lib.mkEnableOption "Godot game engine";
      embedded.enable = lib.mkEnableOption "embedded development (PlatformIO, ESP32, OpenOCD)";
    };

    # Desktop
    desktop = {
      obs.enable = lib.mkEnableOption "OBS Studio";
      libreoffice.enable = lib.mkEnableOption "LibreOffice";
      autorandr.enable = lib.mkEnableOption "autorandr multi-monitor support";
      prusaSlicer.enable = lib.mkEnableOption "PrusaSlicer 3D printing";
    };

    # Editors
    editors = {
      cursor.enable = lib.mkEnableOption "Cursor editor";
    };

    # AI
    ai = {
      llama = {
        enable = lib.mkEnableOption "llama-cpp";
        cuda = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable CUDA support for llama-cpp";
        };
      };
    };
  };

  # No config here - each feature module handles its own mkIf
}
