# AI: llama-cpp
# Enabled via: features.ai.llama.enable = true;
# Use features.ai.llama.cuda = true; for CUDA support
{ lib, config, pkgs, ... }:

let
  cfg = config.features.ai.llama;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (if cfg.cuda then pkgs.llama-cpp.override { cudaSupport = true; } else pkgs.llama-cpp)
    ];
  };
}
