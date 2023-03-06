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
  } @ inputs: let
    system = "x86_64-linux";
    flakePackages = {};

    userConf = import ./configs/users/mcst.nix;
    osConf = import ./configs/os/mcst-desktop.nix;
    homeConf = import ./configs/home/mcst-desktop.nix;
    wgConf = import ./configs/wireguard/kreo.nix;

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
          lib = pkgs.lib;
        };
        modules = [
          ./os
          userConf
          osConf
          wgConf
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

    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home homeConf];
    };
  };
}
