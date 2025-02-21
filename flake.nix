{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-cosmic,
    home-manager,
    ...
  } @ inputs: let
    # Supported systems
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    system = "x86_64-linux";

    forAllSystems = nixpkgs.lib.genAttrs systems;

    args = {
      inherit system inputs;
      inherit (self) outputs;
    };
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

    # Available through i.e. 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;
        modules = [
          nixos-cosmic.nixosModules.default
          ./nixos/xps15-9530.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = args // {isStandalone = false;};
            home-manager.users.mcst = import ./home-manager/mcst.nix;
          }
        ];
      };

      homeserver = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;
        modules = [
          nixos-cosmic.nixosModules.default
          ./nixos/xps15-9560.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = args // {isStandalone = false;};
            home-manager.users.homeserver = import ./home-manager/homeserver.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      "mcst@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = args // {isStandalone = true;};
        modules = [
          ./home-manager/mcst.nix
        ];
      };

      "mcst@fedora" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = args // {isStandalone = true;};
        modules = [
          ./home-manager/mcst-fedora.nix
        ];
      };
    };
  };
}
