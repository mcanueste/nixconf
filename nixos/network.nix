{
  lib,
  config,
  ...
}: {
  options.nixconf.network = {
    hosts = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Hosts file configuration";
    };

    firewall = {
      enable = lib.mkEnableOption "Firewall";

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

    mtr = {
      enable = lib.mkEnableOption "My Traceroute (mtr) network diagnostic tool";

      exportMtr = lib.mkEnableOption "Prometheus-ready mtr exporter";
    };

    wireguard = {
      enable = lib.mkEnableOption "Wireguard";

      configs = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [];
        description = "Wireguard configurations";
      };
    };
  };

  config = {
    networking = {
      # Hosts file setup if needed
      extraHosts = config.nixconf.network.hosts;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;

      # Enable networkmanager
      networkmanager = {enable = true;};

      firewall.enable = config.nixconf.network.firewall.enable;
      firewall.allowedTCPPorts = config.nixconf.network.firewall.allowedTCPPorts;
      firewall.allowedTCPPortRanges = config.nixconf.network.firewall.allowedTCPPortRanges;
      firewall.allowedUDPPorts = config.nixconf.network.firewall.allowedUDPPorts;
      firewall.allowedUDPPortRanges = config.nixconf.network.firewall.allowedUDPPortRanges;

      wg-quick.interfaces = builtins.foldl' (a: b: a // b) {} config.nixconf.network.wireguard.configs;
    };

    # Add user to networkmanager group
    users.users.${config.nixconf.username}.extraGroups = ["networkmanager"];

    programs.mtr.enable = config.nixconf.network.mtr.enable;
    services.mtr-exporter.enable = config.nixconf.network.mtr.exportMtr;
  };
}