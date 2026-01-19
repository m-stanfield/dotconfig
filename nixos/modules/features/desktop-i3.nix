{ config, lib, pkgs, ... }:

with lib;

{
  options.features.desktop-i3 = {
    enable = mkEnableOption "i3 window manager with XFCE desktop environment";
  };

  config = mkIf config.features.desktop-i3.enable {
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraSessionCommands = ''
          eval $(gnome-keyring-daemon --start -d --components=pkcs11,secrets,ssh)
          export SSH_AUTH_SOCK
          ssh-add ~/.ssh/id_ed25519
        '';
      };
      desktopManager = {
        xterm.enable = false;
        wallpaper = {
          combineScreens = false;
          mode = "fill";
        };
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
    };

    services.displayManager = {
      defaultSession = "xfce+i3";
    };

    environment.systemPackages = with pkgs; [
      feh
    ];
  };
}
