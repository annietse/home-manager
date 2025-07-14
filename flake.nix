{
  description = "Shared Home Manager configuration for multiple users";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad-starter = {
      url = "github:hegde-atri/nvconfig";
      flake = false;
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      extraSpecialArgs = { inherit system inputs; };  # <- passing inputs to the attribute set for home-manager
    in {
      homeConfigurations = {
        aknee = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;           # <- this will make inputs available anywhere in the NixOS configuration
          inherit pkgs;
          modules = [ ./users/aknee.nix ];
        };

        mizuuu = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;           # <- this will make inputs available anywhere in the NixOS configuration
          inherit pkgs;
          modules = [ ./users/mizuuu.nix ];
        };
      };
    };
}