# Miscellaneous services
{ config, ... }:

{
  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.blueman.enable = true;

  # ratbagd for gaming mouse configuration (e.g., Piper)
  services.ratbagd.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
