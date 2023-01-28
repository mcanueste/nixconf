{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixconf.network;

  wgKreo = privateKeyFile: {
    kreo = {
      inherit privateKeyFile;
      address = ["10.45.0.30/32"];
      dns = ["10.41.0.2"];
      peers = [
        {
          publicKey = "4HvNXgrqfGeFkhFBXjJelFu+uDcvepN+o0bIdCgUBWw=";
          allowedIPs = ["10.41.0.0/16"];
          endpoint = "3.74.48.98:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  wgKreogpu = privateKeyFile: {
    kreogpu = {
      inherit privateKeyFile;
      address = ["10.46.0.30/32"];
      peers = [
        {
          publicKey = "gGcWwjxTz1/CwfiK3A5bHxbqF2tqfwqybOkEfLJmTSo=";
          allowedIPs = ["10.41.21.0/24"];
          endpoint = "82.222.60.207:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  mkWgConf = enabled: privateKeyFile: config:
    if ! enabled
    then {}
    else config privateKeyFile;
  mkWgInterfaces = configs: builtins.foldl' (i: c: i // c) {} configs;
in {
  options.nixconf.network = {
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

    wgKreoPrivateKeyFile = lib.mkOption {
      default = "";
      description = "Private key file path kreo";
      type = lib.types.str;
    };

    wgKreogpu = lib.mkOption {
      default = false;
      description = "Enable wireguard vpn for kreogpu";
      type = lib.types.bool;
    };

    wgKreogpuPrivateKeyFile = lib.mkOption {
      default = "";
      description = "Private key file path kreogpu";
      type = lib.types.str;
    };
  };

  config = {
    networking.hostName = "nixos";
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager = {
      enable = true;
    };

    networking.wg-quick.interfaces = mkWgInterfaces [
      (mkWgConf cfg.wgKreo cfg.wgKreoPrivateKeyFile wgKreo)
      (mkWgConf cfg.wgKreogpu cfg.wgKreogpuPrivateKeyFile wgKreogpu)
    ];
  };
}
