{
  lib,
  config,
  ...
}: {
  options.nixconf = {
    logitech = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Solaar";
    };
  };

  config = lib.mkIf config.nixconf.logitech {
    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
}
