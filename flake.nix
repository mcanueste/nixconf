{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    homeconf = {
      url = "./home";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    homeconf,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    config = {
      nixconf.network = {
        wgKreo = false;
        wgKreoPrivateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
        wgKreogpu = false;
        wgKreogpuPrivateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
      };
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          homeconf.nixconfModules
          ++ [
            ./os
            config
          ];
      };
    };
  };
}
