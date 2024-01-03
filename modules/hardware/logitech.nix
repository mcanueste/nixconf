{
  lib,
  config,
  ...
}: {
  options.nixconf.hardware = {
    logitech = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Solaar";
    };
  };

  config = lib.mkIf config.nixconf.hardware.logitech {
    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
}
