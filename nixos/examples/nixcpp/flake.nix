{
  description = "A template for Nix based C++ project setup.";


  inputs = {
    # Pointing to the current stable release of nixpkgs. You can
    # customize this to point to an older version or unstable if you
    # like everything shining.
    #
    # E.g.
    #
    # nixpkgs.url = "github:NixOS/nixpkgs/unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs: inputs.utils.lib.eachSystem [
    # Add the system/architecture you would like to support here. Note that not
    # all packages in the official nixpkgs support all platforms.
    "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin"
  ] (system: let
    pkgs = import nixpkgs {
      inherit system;

      # Add overlays here if you need to override the nixpkgs
      # official packages.
      overlays = [];
      
      # Uncomment this if you need unfree software (e.g. cuda) for
      # your project.
      #
      # config.allowUnfree = true;
    };
  in {
    devShells.default = pkgs.mkShell rec {
      # Update the name to something that suites your project.
      name = "my-c++-project";


      buildInputs = with pkgs; [
        # Development Tools
        cmake
        cmakeCurses
        llvmPackages_latest.lldb
        llvmPackages_latest.libllvm
        llvmPackages_latest.libcxx
        llvmPackages_latest.clang
        clang-tools
        gcc

        # Development time dependencies
        gtest

        # Build time and Run time dependencies
        spdlog
        abseil-cpp
        bear
        vscodium
      ];
      packages = with pkgs; [
        # Development Tools
        llvmPackages_latest.lldb
        llvmPackages_latest.libllvm
        llvmPackages_latest.libcxx
        llvmPackages_latest.clang
        clang-tools
        gcc
        cmake
        cmakeCurses

        # Development time dependencies
        gtest

        # Build time and Run time dependencies
        spdlog
        abseil-cpp
        bear
        vscodium
      ];

      # Setting up the environment variables you need during
      # development.
      shellHook = let
        icon = "f121";
      in ''
        echo "entering devshell for ${name}"
      '';
    };

    packages.default = pkgs.callPackage ./default.nix {};
  });
}
