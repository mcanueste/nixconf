{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    gnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gnome desktop";
    };
  };

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.gnome) {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # enable dconf for gnome settings
    programs.dconf.enable = true;

    # Packages
    environment.systemPackages = [
      pkgs.gnome3.gnome-tweaks
    ];

    environment.gnome.excludePackages = [
      pkgs.gnome.baobab # disk usage analyzer
      pkgs.gnome.epiphany # web browser
      pkgs.gnome.gedit # text editor
      pkgs.gnome.simple-scan # document scanner
      pkgs.gnome.totem # video player
      pkgs.gnome.yelp # help viewer
      pkgs.gnome.geary # email client
      pkgs.gnome.seahorse # password manager
      # pkgs.gnome.cheese # photo booth
      # pkgs.gnome.eog # image viewer
      # pkgs.gnome.evince # document viewer
      # pkgs.gnome.file-roller # archive manager

      # these should be self explanatory
      pkgs.gnome.gnome-clocks
      pkgs.gnome.gnome-contacts
      pkgs.gnome.gnome-font-viewer
      pkgs.gnome.gnome-maps
      pkgs.gnome.gnome-music
      pkgs.gnome.gnome-system-monitor
      pkgs.gnome.gnome-weather
      pkgs.gnome.gnome-disk-utility
      pkgs.gnome.gnome-characters

      pkgs.gnome-photos
      pkgs.gnome-connections
      # pkgs.gnome-calculator
      # pkgs.gnome-calendar
      # pkgs.gnome-logs
      # pkgs.gnome-screenshot
    ];
  };
}
