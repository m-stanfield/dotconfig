{ lib, config, pkgs, ...}:

let 
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    autoLogin = lib.mkEnableOption "autologin user";

    userName = lib.mkOption {
      default = "mainuser";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
  users.users.${cfg.userName} = {
    isNormalUser = true;
    initialPassword = "matt";
    description = "matt descirption";
    extraGroups = ["wheel"];
#    shell = pkgs.zsh;
  };
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin = {
    enable = cfg.autoLogin;
    user = cfg.userName;
  };

  };
}
