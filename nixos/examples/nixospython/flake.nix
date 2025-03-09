

{
  description = "Python development environment with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        python = pkgs.python311;
        pythonPackages = python.withPackages (ps: with ps; [
          requests
          numpy
        ]);

      in {
        devShells.default = pkgs.mkShell {
          name = "python-dev-shell";

          # Provide Python and dependencies
          packages = [ python pythonPackages pkgs.virtualenv ];
          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.libz
          ];

          shellHook = ''
            if [ ! -d ".venv" ]; then
              echo "Creating virtual environment in ./.venv..."
              ${python}/bin/python -m venv .venv
              source .venv/bin/activate
              pip install --upgrade pip
              pip install -r requirements.txt
            fi
            source .venv/bin/activate
            echo "Virtual environment activated!"
          '';
        };
      }
    );
}

