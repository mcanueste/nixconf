{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    config = import ./configs/xps15.nix;

    pkgs = import nixpkgs {inherit system;};
  in rec {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          inputs.home-manager.nixosModules.default
          ./modules
          config
        ];
      };
    };

    homeConfigurations = {
      nixos = nixosConfigurations.nixos.home-manager.users.${config.nixconf.user}.home;
    };

    templates = {
      pypoetry = {
        description = "Python with Poetry dev environment flake template.";
        path = ./templates/pypoetry;
      };
    };
  };
}
