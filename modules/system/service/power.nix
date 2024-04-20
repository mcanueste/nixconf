{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service.power = {
    thermald = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable thermald. Only disable on VM's.";
    };

    power-profiles-daemon = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable power-profiles-daemon.";
    };
  };

  config = {
    services = {
      # This will save you money and possibly your life!
      thermald.enable = config.nixconf.system.service.power.thermald;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = config.nixconf.system.service.power.power-profiles-daemon;
    };
  };
}
