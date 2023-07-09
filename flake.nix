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
    config = import ./configs/xps15.nix;

    flakePackages = {};
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "nodejs-16.20.1" # for github-runenr
        ];
      };
      overlays = import ./overlays flakePackages;
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit pkgs;};
        modules = [
          ./os
          config.os
          home-manager.nixosModules.home-manager
          {
            nixpkgs = {inherit pkgs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${config.user.username}.imports = [
              ./home
              config.home
            ];
          }
        ];
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
