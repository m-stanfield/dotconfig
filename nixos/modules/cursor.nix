# Editors: Cursor
# Enabled via: features.editors.cursor.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.editors;
in
{
  config = lib.mkIf cfg.cursor.enable {
    environment.systemPackages = with pkgs; [
      code-cursor
    ];
  };
}
