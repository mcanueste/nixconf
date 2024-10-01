{
  lib,
  config,
  ...
}: {
  options.nixconf.system.network.wireguard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wireguard";
    };

    configs = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "Wireguard configurations";
    };
  };

  config = lib.mkIf config.nixconf.system.network.wireguard.enable {
    networking = {
      # Wireguard configs if any
      wg-quick.interfaces = builtins.foldl' (a: b: a // b) {} config.nixconf.system.network.wireguard.configs;
    };
  };
}
