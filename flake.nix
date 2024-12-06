{
  description = "My personal Nix flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nix-darwin, home-manager, ...}:
  {
    darwinConfigurations = {
      ooj = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ({pkgs, ...}: {
            system.stateVersion = 5;
          })
          home-manager.darwinModules.home-manager
          {
            users.users.ooj.home = "/Users/ooj";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ooj.imports = [
                ({nixpkgs, ...}: {
                  home = {
                    stateVersion = "24.11";
                  };
                })
              ];
            };
          }
        ];
      };
    };
  };
}