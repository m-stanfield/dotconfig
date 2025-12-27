{
  description = "Go development environment with buildGoModule";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      myGoApp = pkgs.buildGoModule {
        pname = "myapp";
        version = "0.1.0";

        src = ./.; # Uses the current directory as source

        vendorSha256 = null; # Change this if using vendored dependencies

        CGO_ENABLED = 1; # Enable CGO
        nativeBuildInputs = with pkgs; [
          gcc
          pkg-config
          delve
        ];
      };
    in
    {
      packages.${system}.default = myGoApp;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          go
          delve
          gcc
          gdb
          pkg-config
        ];
        hardeningDisable = [ "fortify" ];

        shellHook = ''
          export CGO_ENABLED=1
          export PATH=$PATH:$(go env GOPATH)/bin
          echo "Go development environment ready!"
        '';
      };
    };
}
