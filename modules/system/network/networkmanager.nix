{
  lib,
  config,
  ...
}: {
  options.nixconf.system.network.networkmanager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable networkmanager";
    };
  };

  config = lib.mkIf config.nixconf.system.network.networkmanager.enable {
    networking = {
      networkmanager = {enable = true;};
    };

    users.users.${config.nixconf.user}.extraGroups = ["networkmanager"];
  };
}
