{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    catppuccin,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    config = import ./configs/xps15.nix;
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {allowUnfree = true;};
    };
  in rec {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs pkgs-stable;
        };
        modules = [
          home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          ./modules
          config
        ];
      };
    };

    homeConfigurations = {
      nixos = nixosConfigurations.nixos.home-manager.users.${config.nixconf.system.user}.home;
    };
  };
}
