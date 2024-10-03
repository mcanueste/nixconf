{
  lib,
  config,
  ...
}: {
  options.nixconf.os.service.dbus = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable D-Bus for interprocess communication";
    };

    tumbler = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Service for applications to request thumbnails for various URI schemes and Mime types";
    };
  };

  config = {
    services = {
      dbus.enable = config.nixconf.os.service.dbus.enable;
      tumbler.enable = config.nixconf.os.service.dbus.tumbler;
    };
  };
}
