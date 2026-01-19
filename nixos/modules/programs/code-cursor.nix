{ config, lib, pkgs, ... }:

with lib;

{
  options.features.code-cursor = {
    enable = mkEnableOption "Cursor AI code editor";
  };

  config = mkIf config.features.code-cursor.enable {
    environment.systemPackages = with pkgs; [
      code-cursor
    ];
  };
}
