{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/nvim";

  home.packages = with pkgs; [
    neovim

    # Lua
    lua-language-server
    luarocks

    # Nix
    nixd
    nixfmt-rfc-style

    # System tools
    xclip
    tree-sitter
    ripgrep
    unzip

    # TypeScript/JavaScript
    typescript-language-server
    nodejs
    prettierd

    # C/C++
    clang
    llvm

    # Python
    python3
    python3Packages.pynvim
    python3Packages.debugpy
    ruff

    # Go
    go
    gopls
    delve

    # Other formatters
    rustywind
    stylua
  ];

  # Alias vim to nvim
  home.shellAliases.vim = "nvim";
}
