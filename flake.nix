{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-alien,
    nix-flatpak,
    nixos-cosmic,
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

    cache-config = {
      nix.settings = {
        substituters = ["https://cosmic.cachix.org/"];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        ];
      };
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit system inputs pkgs-stable;
        };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nixos-cosmic.nixosModules.default
          home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          ./modules
          config
          cache-config
        ];
      };
    };
  };
}
