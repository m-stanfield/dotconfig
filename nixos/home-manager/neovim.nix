{ config, pkgs, lib, inputs, ... }:

{

  home.file."${config.home.homeDirectory}/.config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotconfig/config/nvim";
  };
#  home.activation.linkNeovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#    ln -sfn "$HOME/code/dotconfig/config/nvim" "$HOME/.config/nvim"
#  '';

 programs.neovim = {
   vimAlias = true;
   enable = true;
       # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
   extraLuaPackages = luaPkgs: with luaPkgs; [ luarocks];

   extraPackages = with pkgs; [
   xclip
    clang
    llvm
    python3
    python3Packages.pynvim  # Required for Python Neovim support
    python3Packages.debugpy

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

  # Debugging tools

  # Language servers
  nodePackages.vscode-langservers-extracted # Includes html-lsp, css-lsp, eslint-lsp

  # Other Mason dependencies
  unzip    # Needed for Mason tools
  ripgrep  # Improves LSP performance in Neovim

  ];
 };

}
