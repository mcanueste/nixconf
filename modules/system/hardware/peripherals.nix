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
    # Enable hardware support for bluetooth
    hardware.bluetooth = {
      enable = config.nixconf.system.hardware.peripherals.bluetooth;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    # Enable blueman for bluetooth control
    services.blueman.enable = config.nixconf.system.hardware.peripherals.bluetooth;

    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = config.nixconf.system.hardware.peripherals.logitech;
        enableGraphical = true;
      };
    };
  };
}
