{
  pkgs,
  lib,
  config,
  ...
}: let
  timezone = "Europe/Berlin";
  language = "en_US.UTF-8";
  format = "de_DE.UTF-8";
in {
  # ----- Locale
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

  # ----- Keyboard cfg
  services.xserver = {
    # Configure keymap in X11
    layout = "us,de";
    xkbModel = "pc105";
    xkbOptions = "caps:escape,grp:win_space_toggle";
  };
  console.useXkbConfig = true;

  # ----- Sound cfg (pipewire)
  # Remove sound.enable or set it to false as it is only meant for ALSA-based configurations
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false; # for jack applications
  };

  # ----- Other stuff

  # Seamlessly access files and folders on remote resources.
  # Necessarry for file managers, mounts, trash, etc.
  services.gvfs.enable = true;

  # Tumbler is a D-Bus service for applications to request thumbnails
  # for various URI schemes and MIME types.
  services.tumbler.enable = true;

  # ----- Nix Specific
  system.stateVersion = "23.11"; # not considered since we use unstable via flake, but anyways
  nix = {
    settings = {
      auto-optimise-store = true; # optimise after each build
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
    optimise.automatic = true; # optimise daily
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
