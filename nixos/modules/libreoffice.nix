# Desktop: LibreOffice
# Enabled via: features.desktop.libreoffice.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.desktop;
in
{
  config = lib.mkIf cfg.libreoffice.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt
      jre_minimal
      hunspell
      hunspellDicts.uk_UA
    ];
  };
}
