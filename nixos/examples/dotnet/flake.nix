{
  description = "A .NET development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.dotnet-sdk_8 # Latest stable .NET SDK version
            pkgs.dotnet-runtime_8
            pkgs.nodejs # Useful for frontends in .NET projects
            pkgs.postgresql # Example database dependency
          ];

          DOTNET_ROOT = pkgs.dotnet-sdk_8; # Ensures tooling finds .NET
          shellHook = ''
            export PATH=$PATH:${pkgs.dotnet-sdk_8}/bin
            echo "Development environment ready 🚀"
          '';
        };
      }
    );
}
