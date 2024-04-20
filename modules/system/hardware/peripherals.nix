{
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.peripherals = {
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Bluetooth";
    };

    logitech = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Solaar";
    };
  };

  config = {
    hardware.bluetooth = {
      enable = config.nixconf.system.hardware.peripherals.bluetooth;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = config.nixconf.system.hardware.peripherals.logitech;
        enableGraphical = true;
      };
    };
  };
}
