{ config, pkgs, lib, inputs, ... }:

{

  xdg.configFile.nvim.source = ../../config/nvim;
 programs.neovim = {
   vimAlias = true;
   enable = true;
       package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
   extraLuaPackages = luaPkgs: with luaPkgs; [ luarocks];

   extraPackages = with pkgs; [
    clang
    llvm
    python3
    python3Packages.pynvim  # Required for Python Neovim support

    # Go
    go
    gopls  # Go LSP for autocompletion

    # Node.js
    nodejs
    nodePackages.pnpm  # Optional: npm or yarn
    nodePackages.neovim  # Required for Node-based Neovim plugins

    prettierd
    isort
    black
    stylua
    #eslint
    delve

  ];
 };
}
