{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  home.file = {
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/claude/CLAUDE.md";
    };
  };

  home.packages = [
    pkgs.claude-code
  ];
}
