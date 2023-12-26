{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    config = import ./configs/xps15.nix;
    homeConfig = import ./configs/home.nix;
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # obsidian 1.4.16 depends on this EOL electron?????
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
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit pkgs inputs homeConfig;};
        modules = [
          inputs.home-manager.nixosModules.default
          ./modules/os
          config
        ];
      };
    };
  };
}
