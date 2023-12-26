{
  lib,
  config,
  ...
}: {
  options.nixconf.network = {
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Network hostname";
    };

    hosts = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Hosts file configuration";
    };

    wireguard.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wireguard";
    };

    wireguard.configs = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "Wireguard configurations";
    };

    exportMtr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Prometheus-ready mtr exporter";
    };
  };

  config = {
    users.users.${config.nixconf.user.username}.extraGroups = ["networkmanager"];
    networking = {
      hostName = config.nixconf.network.hostname;
      networkmanager = {enable = true;};

      # Hosts file setup if needed
      extraHosts = config.nixconf.network.hosts;

      # # --- Wireguard configs if any
      wg-quick.interfaces = builtins.foldl' (a: b: a // b) {} config.nixconf.network.wireguard.configs;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;

      # Open ports in the firewall.
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];

      # Or disable the firewall altogether.
      firewall.enable = false;
    };

    # network diagnostic tool (requires sudo) = ping + traceroute
    programs.mtr.enable = true;
    services.mtr-exporter.enable = config.nixconf.network.exportMtr;
  };
}
