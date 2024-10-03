{
  lib,
  config,
  ...
}: {
  options.nixconf.hardware.peripherals = {
    touchpad = lib.mkEnableOption "Touchpad";

    bluetooth = lib.mkEnableOption "Bluetooth";

    logitech = lib.mkEnableOption "Logitech (Solaar)";
  };

  config = {
    # Enable touchpad
    services.libinput.enable = config.nixconf.hardware.peripherals.touchpad;

    # Enable hardware support for bluetooth
    hardware.bluetooth = {
      enable = config.nixconf.hardware.peripherals.bluetooth;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket"; # enable A2DP profile
          Experimental = true; # show battery charge status
        };
      };
    };

    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = config.nixconf.hardware.peripherals.logitech;
        enableGraphical = true;
      };
    };
  };
}
