# Audio: PipeWire configuration
{ config, pkgs, ... }:

{
  # rtkit enables realtime scheduling for audio processes
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
