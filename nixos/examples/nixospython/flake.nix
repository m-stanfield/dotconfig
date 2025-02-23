{
  description = "Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    devShells.default = with import nixpkgs { system = "x86_64-linux"; };
      mkShell {
        buildInputs = [
          python311
          python311Packages.pip
          python311Packages.virtualenv
        ];
      };
  };
}

