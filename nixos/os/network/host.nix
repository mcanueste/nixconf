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
  };

  config = {
    networking = {
      hostName = config.nixconf.network.hostname;

      # Hosts file setup if needed
      extraHosts = config.nixconf.network.hosts;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;

      # Enable networkmanager
      networkmanager = {enable = true;};
    };

    # Add user to networkmanager group
    users.users.${config.nixconf.user}.extraGroups = ["networkmanager"];
  };
}
