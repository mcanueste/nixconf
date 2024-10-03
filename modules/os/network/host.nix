{
  lib,
  config,
  ...
}: {
  options.nixconf.os.network = {
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
      hostName = config.nixconf.os.network.hostname;

      # Hosts file setup if needed
      extraHosts = config.nixconf.os.network.hosts;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;

      # Enable networkmanager
      networkmanager = {enable = true;};
    };

    # Add user to networkmanager group
    users.users.${config.nixconf.os.user}.extraGroups = ["networkmanager"];
  };
}
