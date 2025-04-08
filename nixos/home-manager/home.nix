{ config, pkgs, lib, ... }:

{
  imports = [
    ./tmux.nix
    ./neovim.nix
    ./i3.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "matt";
  home.homeDirectory = "/home/matt";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?

    python3
    python3Packages.debugpy
    python3Packages.pip
    cura-appimage


    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
    home.activation.createDebugpyVenv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.virtualenvs/debugpy" ]; then
      ${pkgs.python3}/bin/python -m venv $HOME/.virtualenvs/debugpy
    fi
    source $HOME/.virtualenvs/debugpy/bin/activate
    $HOME/.virtualenvs/debugpy/bin/pip install --upgrade pip
    $HOME/.virtualenvs/debugpy/bin/pip install debugpy
  '';


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
#    ".config.source" = ../../config;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/testName/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "neovim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  services.ssh-agent.enable = true;


  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size=10;
    };
    shellIntegration.enableFishIntegration = true;
    theme = "Catppuccin-Mocha";
  };


  programs.git = {
    enable = true;
    userName = "m-stanfield";
    userEmail = "mattstanfield52@gmail.com";
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.rofi = {
  enable = true;
  theme = "arthur"; 
  extraConfig = {
  terminal = "kitty";
  modi = "drun,run,window,filebrowser";

  show-icons = true;

  # can you make symbols for the display options?
  display-run = "";
  display-window = "";
  display-filebrowser = "";
  display-drun = "";

  };

  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];
  };
}
