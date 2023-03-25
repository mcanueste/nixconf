{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.network;
  mkWgInterfaces = builtins.foldl' (i: c: i // c) {};
in {
  options.nixos.network = {
    hostname = lib.mkOption {
      default = "nixos";
      description = "Network hostname";
      type = lib.types.str;
    };

    wireguard.enable = lib.mkOption {
      default = true;
      description = "Enable wireguard";
      type = lib.types.bool;
    };

    wireguard.configs = lib.mkOption {
      default = [];
      description = "Wireguard configurations";
      type = lib.types.anything;
    };

    wireguard.certs = lib.mkOption {
      default = [];
      description = "CA paths";
      type = lib.types.listOf lib.types.path;
    };
  };

  config = {
    networking.hostName = "nixos";
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager = {enable = true;};
    networking.wg-quick.interfaces = mkWgInterfaces cfg.wireguard.configs;
    security.pki.certificateFiles = cfg.wireguard.certs;
  };
}
