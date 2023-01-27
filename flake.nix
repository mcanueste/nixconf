{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    config = {
      nixpkgs = {inherit pkgs;};
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.mcst = import ./home;

      nixconf.network = {
        wgKreo = true;
        wgKreoPrivateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
        wgKreogpu = true;
        wgKreogpuPrivateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
      };
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./os
          home-manager.nixosModules.home-manager
          config
        ];
      };
    };
  };
}
