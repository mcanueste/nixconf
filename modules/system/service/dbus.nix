{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service.dbus = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable D-Bus for interprocess communication";
    };

    tumbler = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Service for applications to request thumbnails for various URI schemes and Mime types";
    };
  };

  config = {
    services = {
      dbus.enable = config.nixconf.system.service.dbus.enable;
      tumbler.enable = config.nixconf.system.service.dbus.tumbler;
    };
  };
}
