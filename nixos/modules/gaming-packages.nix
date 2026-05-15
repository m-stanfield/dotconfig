# Gaming: Lutris, RetroArch, XIVLauncher
# Enabled via: features.gaming.enable = true;
{ lib, config, pkgs, ... }:

let
  cfg = config.features.gaming;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraLibraries =
          pkgs: with pkgs; [
            libadwaita
            gtk4
          ];
        buildFHSEnv = args: pkgs.buildFHSEnv (args // {
          multiPkgs = envPkgs:
            let
              originalPkgs = args.multiPkgs envPkgs;
              customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
            in
            builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
        });
      })
      (retroarch.withCores (
        cores: with cores; [
          desmume
        ]
      ))
      xivlauncher
      mgba
    ];
  };
}
