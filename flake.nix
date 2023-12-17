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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ # obsidian 1.4.16 depends on this EOL electron?????
          "electron-25.9.0"
        ];
        packageOverrides = pkg: {
          vaapiIntel = pkg.vaapiIntel.override {enableHybridCodec = true;};
          steam = pkg.steam.override {
            extraPkgs = pkg:
              with pkg; [
                gamescope
                mangohud
              ];
          };
        };
      };
      overlays = [
        (final: prev: prev.lib.attrsets.recursiveUpdate prev {lib.conflib = import ./modules/lib {inherit (prev) lib;};})
      ];
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit pkgs;};
        modules = [
          ./modules/os
          config.os
          home-manager.nixosModules.home-manager
          {
            nixpkgs = {inherit pkgs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${config.user.username}.imports = [
              ./modules/home
              config.home
            ];
          }
        ];
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
