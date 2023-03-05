{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.network;

  wgKreo = {
    kreo = {
      address = ["10.45.0.30/32"];
      dns = ["10.41.0.2"];
      # dns = ["10.42.21.1"];
      privateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
      peers = [
        {
          publicKey = "4HvNXgrqfGeFkhFBXjJelFu+uDcvepN+o0bIdCgUBWw=";
          allowedIPs = ["10.41.0.0/16" "10.42.21.0/24"];
          endpoint = "3.74.48.98:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  mkWgInterfaces = configs: builtins.foldl' (i: c: i // c) {} configs;
in {
  options.nixos.network = {
    hostname = lib.mkOption {
      default = "nixos";
      description = "Network hostname";
      type = lib.types.str;
    };

    wgKreo = lib.mkOption {
      default = false;
      description = "Enable wireguard vpn for kreo";
      type = lib.types.bool;
    };
  };

  config = {
    networking.hostName = "nixos";
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager = {
      enable = true;
    };

    networking.wg-quick.interfaces = mkWgInterfaces [
      (
        if cfg.wgKreo
        then wgKreo
        else {}
      )
    ];
  };
}
