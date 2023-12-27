let
  timezone = "Europe/Berlin";
  language = "en_US.UTF-8";
  format = "de_DE.UTF-8";
in {
  time.timeZone = timezone;
  i18n.defaultLocale = language;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = format;
    LC_IDENTIFICATION = format;
    LC_MEASUREMENT = format;
    LC_MONETARY = format;
    LC_NAME = format;
    LC_NUMERIC = format;
    LC_PAPER = format;
    LC_TELEPHONE = format;
    LC_TIME = format;
  };

  # Configure keymap in X11 just in case we decide to use X11 based WM
  services.xserver = {
    layout = "us,de";
    xkbModel = "pc105";
    xkbOptions = "caps:escape,grp:win_space_toggle";
  };
  console.useXkbConfig = true;
}
