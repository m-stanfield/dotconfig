{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:  let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/default/configuration.nix
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./configuration.nix
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };
    };
  };
}
