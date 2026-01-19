# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme1n1";
  boot.loader.grub.useOSProber = true;

  systemd.tmpfiles.rules = [
    # Type Path        Mode    UID     GID     Age  Argument
    "d     /mnt/ssd    0755    1000    100     -    -"
  ];
  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/1e447dce-19ff-4a88-a30c-8586c8f4bee3";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  # Enable features specific to this host
  features = {
    desktop-i3.enable = true;
    docker.enable = true;
    steam.enable = true;
    obs.enable = true;
    code-cursor.enable = true;
    libreoffice.enable = true;
    virtualbox = {
      enable = true;
      users = [ "matt" ];
    };
    autorandr = {
      enable = true;
      profiles = {
        "full" = {
          fingerprint = {
            DP-0 = "00ffffffffffff004c2d9c0f000000002b1c0104b57722783ba2a1ad4f46a7240e5054bfef80714f810081c08180a9c0b3009500d1c074d600a0f038404030203a00a9504100001a000000fd003078bebe61010a202020202020000000fc00433439524739780a2020202020000000ff004831414b3530303030300a202002ce02032cf046105a405b3f5c2309070783010000e305c0006d1a0000020f307800048b127317e60605018b7312565e00a0a0a0295030203500a9504100001a584d00b8a1381440f82c4500a9504100001e1a6800a0f0381f4030203a00a9504100001af4b000a0f038354030203a00a9504100001a0000000000000000000000af701279000003013c57790188ff139f002f801f009f055400020009006c370108ff139f002f801f009f0545000200090033b70008ff139f002f801f009f0528000200090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f390";
            HDMI-0 = "00ffffffffffff0005e3012710090200191e0103803c22782adad5ad5048a625125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a029503020350055502100001e40e7006aa0a067500820980455502100001a000000fc0051323747315747340a20202020000000fd0030901ee63c000a202020202020011d020330f14c101f0514041303120211013f230907078301000065030c00100067d85dc401788000681a000001013090e66fc200a0a0a055503020350055502100001e5aa000a0a0a046503020350055502100001e023a801871382d40582c450055502100001ef03c00d051a0355060883a0055502100001c00000000000000fd";
          };

          hooks.preswitch = {
            "merge-monitors" = ''
              xrandr --delmonitor "DP-0-1"
              xrandr --delmonitor "DP-0-2"
              xrandr --delmonitor "DP-0-3"
            '';
          };

          hooks.postswitch = {
            "rescale-background" = ''
              feh --bg-scale ~/.background-image
            '';
          };

          config = {
            HDMI-0 = {
              enable = true;
              position = "1280x0";
              mode = "2560x1440";
              rate = "99.95";
              crtc = 1;
            };
            DP-0 = {
              enable = true;
              mode = "5120x1440";
              primary = true;
              position = "0x1440";
              rate = "119.97";
              crtc = 0;
            };
          };
        };

        "desk" = {
          fingerprint = {
            DP-0 = "00ffffffffffff004c2d9c0f000000002b1c0104b57722783ba2a1ad4f46a7240e5054bfef80714f810081c08180a9c0b3009500d1c074d600a0f038404030203a00a9504100001a000000fd003078bebe61010a202020202020000000fc00433439524739780a2020202020000000ff004831414b3530303030300a202002ce02032cf046105a405b3f5c2309070783010000e305c0006d1a0000020f307800048b127317e60605018b7312565e00a0a0a0295030203500a9504100001a584d00b8a1381440f82c4500a9504100001e1a6800a0f0381f4030203a00a9504100001af4b000a0f038354030203a00a9504100001a0000000000000000000000af701279000003013c57790188ff139f002f801f009f055400020009006c370108ff139f002f801f009f0545000200090033b70008ff139f002f801f009f0528000200090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f390";
            HDMI-0 = "00ffffffffffff0005e3012710090200191e0104a53c22783bdad5ad5048a625125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a029503020350055502100001e40e7006aa0a067500820980455502100001a000000fc0051323747315747340a20202020000000fd003090e6e63c010a202020202020011d02031ff14c0103051404131f120211903f230907078301000065030c0010006fc200a0a0a055503020350055502100001e5aa000a0a0a046503020350055502100001e023a801871382d40582c450055502100001eab22a0a050841a303020360055502100001af03c00d051a0355060883a0055502100001c00000000000080";
          };

          hooks.postswitch = {
            "split-monitors" = ''
              xrandr --setmonitor "DP-0-1" 1280/1280x1440/173+0+1440 none &&
              xrandr --setmonitor "DP-0-2" 2560/2560x1440/173+1280+1440 none &&
              xrandr --setmonitor "DP-0-3" 1280/1280x1440/173+3840+1440 none
            '';
            "rescale-background" = ''
              feh --bg-scale ~/.background-image
            '';
          };

          config = {
            HDMI-0 = {
              enable = true;
              position = "1280x0";
              mode = "2560x1440";
              rate = "99.95";
              crtc = 1;
            };
            DP-0 = {
              enable = true;
              mode = "5120x1440";
              primary = true;
              position = "0x1440";
              rate = "119.97";
              crtc = 0;
            };
          };
        };
      };
    };
  };

}
