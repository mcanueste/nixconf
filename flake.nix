{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixhome = {
      url = "github:mcanueste/nixhome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixhome,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = nixhome.lib.mkPkgs {
      inherit nixpkgs system;
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
          nixhome.nixconfModules
          ++ [
            ./modules
            config
          ];
      };
    };
  };
}
