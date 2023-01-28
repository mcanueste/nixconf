{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixconf.locale;
in {
  options.nixconf.locale = {
    timezone = lib.mkOption {
      default = "Europe/Berlin";
      description = "Time Zone";
      example = "Europe/Berlin";
      type = lib.types.str;
    };

    language = lib.mkOption {
      default = "en_US.UTF-8";
      description = "Default locale of the system.";
      example = "en_US.UTF-8";
      type = lib.types.str;
    };

    format = lib.mkOption {
      default = "de_DE.UTF-8";
      description = "Locale to be used as monetary, numeric, time, etc. format.";
      example = "de_DE.UTF-8";
      type = lib.types.str;
    };
  };

  config = {
    time.timeZone = cfg.timezone;
    i18n.defaultLocale = cfg.language;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.format;
      LC_IDENTIFICATION = cfg.format;
      LC_MEASUREMENT = cfg.format;
      LC_MONETARY = cfg.format;
      LC_NAME = cfg.format;
      LC_NUMERIC = cfg.format;
      LC_PAPER = cfg.format;
      LC_TELEPHONE = cfg.format;
      LC_TIME = cfg.format;
    };
  };
}
