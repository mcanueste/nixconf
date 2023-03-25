{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    xpsConf = import ./configs/xps15.nix;

    flakePackages = {};
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = import ./overlays flakePackages;
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs;
          inherit (pkgs) lib;
        };
        modules = [
          ./os
          xpsConf
          home-manager.nixosModules.home-manager
          {
            nixpkgs = {inherit pkgs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mcst = ./home;
            # config = homeConf;
          }
        ];
      };
    };
  };
}
