{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.de = {
    gnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Gnome desktop environment";
    };
  };

  config = lib.mkIf (config.nixconf.system.desktop.enable && config.nixconf.system.desktop.de.gnome) {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };

    # Packages
    environment.systemPackages = [
      pkgs.gnome3.gnome-tweaks
      pkgs.gnomeExtensions.forge
    ];

    environment.gnome.excludePackages = [
      pkgs.gnome.baobab # disk usage analyzer
      pkgs.gnome.gnome-system-monitor
      pkgs.gnome.gnome-disk-utility
      pkgs.gnome.seahorse # password manager
      pkgs.gnome.gnome-characters
      pkgs.gnome.gnome-contacts
      pkgs.gnome.gnome-music
      pkgs.gnome.epiphany # web browser
      pkgs.gnome.geary # email client
      pkgs.gnome.totem # video player
      pkgs.gnome.yelp # help viewer
      pkgs.gnome.simple-scan # document scanner
      pkgs.gnome-connections
      # pkgs.gnome-photos
      # pkgs.gnome.eog # image viewer
      # pkgs.gnome.cheese # photo booth
      # pkgs.gnome.evince # document viewer
      # pkgs.gnome.file-roller # archive manager
      # pkgs.gnome.gnome-font-viewer
      # pkgs.gnome.gnome-clocks
      # pkgs.gnome.gnome-weather
      # pkgs.gnome.gnome-maps
      # pkgs.gnome-calculator
      # pkgs.gnome-calendar
      # pkgs.gnome-logs
      # pkgs.gnome-screenshot
    ];
  };
}
