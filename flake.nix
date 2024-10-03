{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

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
    inherit (self) outputs;

    # Supported systems
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    system = "x86_64-linux";

    forAllSystems = nixpkgs.lib.genAttrs systems;

    config = import ./configs/xps15.nix;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Custom overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules (upstream into nixpkgs)
    nixosModules = import ./modules/nixos;

    # Reusable home-manager modules (upstream into home-manager)
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit system inputs outputs;
        };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nixos-cosmic.nixosModules.default
          home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          ./nixos
          config
        ];
      };
    };
  };
}
