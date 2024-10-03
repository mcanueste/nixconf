{
  lib,
  config,
  ...
}: {
  options.nixconf.service.power = {
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
      thermald.enable = config.nixconf.service.power.thermald;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = config.nixconf.service.power.power-profiles-daemon;
    };
  };
}
