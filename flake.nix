{
  description = "Shared Home Manager configuration for multiple users";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        aknee = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/aknee.nix ];
        };

        mizuuu = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/mizuuu.nix ];
        };
      };
    };
}
