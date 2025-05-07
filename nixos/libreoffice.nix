
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ 
      libreoffice-qt
      jre_minimal
      hunspell
      hunspellDicts.uk_UA        
  ];
}
