# Network configuration
{ config, lib, ... }:

{
  networking.networkmanager.enable = true;

  # Default hostname, can be overridden per-host
  networking.hostName = lib.mkDefault "nixos";

  networking.firewall.allowedTCPPorts = [
    3000
    8080
  ];
}
