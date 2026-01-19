{ config, lib, pkgs, ... }:

with lib;

{
  options.features.libreoffice = {
    enable = mkEnableOption "LibreOffice office suite";
  };

  config = mkIf config.features.libreoffice.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt
      jre_minimal
      hunspell
      hunspellDicts.uk_UA
    ];
  };
}
