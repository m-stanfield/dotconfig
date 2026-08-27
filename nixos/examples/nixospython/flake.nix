{
  description = "Python development environment with Nix and uv";

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

        python = pkgs.python311;

      in
      {
        devShells.default = pkgs.mkShell {
          name = "python-dev-shell";

          # uv manages the virtualenv and Python dependencies.
          packages = [
            python
            pkgs.uv
          ];
          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
          ];

          shellHook = ''
            if [ ! -x ".venv/bin/python" ]; then
              echo "Creating virtual environment in ./.venv..."
              uv venv --python ${python}/bin/python .venv
            fi

            source .venv/bin/activate
            uv sync --no-install-project
            echo "Virtual environment activated!"
          '';
        };
      }
    );
}
