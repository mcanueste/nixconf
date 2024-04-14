{
  lib,
  config,
  ...
}: {
  options.nixconf.system.network.firewall = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable firewall";
    };

    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      example = [22 80];
      description = "List of TCP ports on which incoming connections are accepted.";
    };

    allowedTCPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.port);
      default = [];
      example = [
        {
          from = 8999;
          to = 9003;
        }
      ];
      description = "A range of TCP ports on which incoming connections are accepted.";
    };

    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      example = [53];
      description = "List of open UDP ports.";
    };

    allowedUDPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.port);
      default = [];
      example = [
        {
          from = 60000;
          to = 61000;
        }
      ];
      description = "Range of open UDP ports.";
    };
  };

  config = {
    networking = {
      firewall.enable = config.nixconf.system.network.firewall.enable;
      firewall.allowedTCPPorts = config.nixconf.system.network.firewall.allowedTCPPorts;
      firewall.allowedTCPPortRanges = config.nixconf.system.network.firewall.allowedTCPPortRanges;
      firewall.allowedUDPPorts = config.nixconf.system.network.firewall.allowedUDPPorts;
      firewall.allowedUDPPortRanges = config.nixconf.system.network.firewall.allowedUDPPortRanges;
    };
  };
}
