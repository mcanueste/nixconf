{
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.peripherals = {
    touchpad = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable touchpad";
    };

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
    # Enable touchpad
    services.libinput.enable = config.nixconf.system.hardware.peripherals.touchpad;

    # Enable hardware support for bluetooth
    hardware.bluetooth = {
      enable = config.nixconf.system.hardware.peripherals.bluetooth;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket"; # enable A2DP profile
          Experimental = true;  # show battery charge status
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
