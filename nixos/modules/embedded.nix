{ lib, config, pkgs, ... }:

let
  cfg = config.features.development;
in
{
  config = lib.mkIf cfg.embedded.enable {
    # Tools for embedded development (ESP32, PlatformIO, JTAG)
    environment.systemPackages = with pkgs; [
      platformio-core
      esptool
      openocd
    ];

    # Serial port access for ESP32 dev boards
    users.users.matt.extraGroups = [ "dialout" ];

    # udev rules from openocd (covers FTDI, CMSIS-DAP adapters)
    services.udev.packages = [ pkgs.openocd ];

    # Additional udev rules for common ESP32 USB chips
    services.udev.extraRules = ''
      # Silicon Labs CP210x (NodeMCU, ESP32-DevKitC)
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", GROUP="dialout", MODE="0664"
      # WCH CH340/CH341 (common on budget ESP32 boards)
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", GROUP="dialout", MODE="0664"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", GROUP="dialout", MODE="0664"
      # FTDI FT232R
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="dialout", MODE="0664"
      # FTDI FT2232H (ESP-Prog JTAG adapter)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", GROUP="dialout", MODE="0664"
      # Espressif ESP32-S3/C3/C6 built-in USB JTAG
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", GROUP="dialout", MODE="0664"
    '';
  };
}
