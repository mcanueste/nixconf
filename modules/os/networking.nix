{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.network;
  mkWgInterfaces = builtins.foldl' (i: c: i // c) {};
in {
  options.nixos.network = {
    hostname = lib.mkOption {
      default = "nixos";
      description = "Network hostname";
      type = lib.types.str;
    };

    wireguard.enable = mkBoolOption {description = "Enable wireguard"; default = false;};

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
    networking.hostName = "${cfg.hostname}";
    networking.networkmanager = {enable = true;};

    # --- Wireguard config
    networking.wg-quick.interfaces = mkWgInterfaces cfg.wireguard.configs;
    security.pki.certificateFiles = cfg.wireguard.certs;
  };
}
