{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom nixvim configuration flake
    nixvim = {
      url = "github:mcanueste/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = import ./lib;
    packages = {
      nixvim = nixvim.packages.${system}.nixvim;
    };
    config = {};
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        (import ./overlays/rose_pine_tmux.nix)
        (import ./overlays/tmux_session_wizard.nix)
      ];
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./os
          home-manager.nixosModules.home-manager
          {
            nixpkgs = {inherit pkgs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mcst = import ./home;
          }
        ];
      };
    };
  };
}
