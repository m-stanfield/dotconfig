# Network configuration
{ config, lib, ... }:

{
  networking.networkmanager.enable = true;

  # Default hostname, can be overridden per-host
  networking.hostName = lib.mkDefault "nixos";

  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
    5173
    8080
    8888
  ];
}
