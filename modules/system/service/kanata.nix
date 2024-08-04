{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service = {
    kanata = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kanata.";
    };
  };

  config = lib.mkIf config.nixconf.system.service.kanata {
    users.users.${config.nixconf.system.user}.extraGroups = [
      "input"
      "uinput"
    ];

    services.kanata = {
      enable = true;
      keyboards.default = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-id/usb-Logitech_USB_Receiver-event-kbd"
        ];
        config = ''
          (defsrc)
          (deflayermap (base-layer)
            caps esc
          )
        '';
      };
    };
  };
}
