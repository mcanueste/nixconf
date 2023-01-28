{
  description = "Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:mcanueste/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
    lib = import ./lib;
    modules = import ./modules;
    pkgs = lib.mkPkgs {
      inherit nixpkgs system;
      config = {allowUnfree = true;};
      packages = { inherit nixvim; };
    };
  in {
    inherit lib;

    formatter.${system} = pkgs.alejandra;

    nixconfModules = [
      home-manager.nixosModules.home-manager
      {
        nixpkgs = {inherit pkgs;};
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.mcst = modules;
      }
    ];

    homeConfigurations.mcst = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [modules];
    };
  };
}
