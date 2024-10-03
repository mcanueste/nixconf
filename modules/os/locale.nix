{
  lib,
  config,
  ...
}: {
  options.nixconf.os.locale = {
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Timezone to use for the system";
    };

    language = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Language to use for the system";
    };

    format = lib.mkOption {
      type = lib.types.str;
      default = "de_DE.UTF-8";
      description = "Format to use for the system";
    };

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us,de";
      description = "List of keyboard layouts to use";
    };
  };

  config = {
    time.timeZone = config.nixconf.os.locale.timezone;
    i18n.defaultLocale = config.nixconf.os.locale.language;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = config.nixconf.os.locale.format;
      LC_IDENTIFICATION = config.nixconf.os.locale.format;
      LC_MEASUREMENT = config.nixconf.os.locale.format;
      LC_MONETARY = config.nixconf.os.locale.format;
      LC_NAME = config.nixconf.os.locale.format;
      LC_NUMERIC = config.nixconf.os.locale.format;
      LC_PAPER = config.nixconf.os.locale.format;
      LC_TELEPHONE = config.nixconf.os.locale.format;
      LC_TIME = config.nixconf.os.locale.format;
    };

    # Configure keymap in X11 just in case we decide to use X11 based WM
    services.xserver = {
      xkb = {
        model = "pc105";
        # options = "caps:escape,grp:win_space_toggle";  # using kanata
        layout = config.nixconf.os.locale.layout;
      };
    };
    console.useXkbConfig = true;
  };
}
