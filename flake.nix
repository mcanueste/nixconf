{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    lib = import ./lib;

    userConf = import ./configs/users/mcst.nix;
    osConf = import ./configs/os/mcst-desktop.nix;
    homeConf = import ./configs/home/mcst-desktop.nix;
    wgConf = import ./configs/wireguard/kreo.nix;

    pkgs = lib.mkPkgs {
      inherit nixpkgs system;
      config = {allowUnfree = true;};
      packages = {inherit nixvim;};
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
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
