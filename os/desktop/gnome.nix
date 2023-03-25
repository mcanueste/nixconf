{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.desktop.gnome;
in {
  options.nixos.desktop.gnome = {
    enable = lib.mkOption {
      default = true;
      description = "Enable gnome desktop";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # enable dconf
    programs.dconf.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
      gnome3.gnome-tweaks
    ];

    environment.gnome.excludePackages = with pkgs.gnome; [
      baobab # disk usage analyzer
      epiphany # web browser
      gedit # text editor
      simple-scan # document scanner
      totem # video player
      yelp # help viewer
      geary # email client
      seahorse # password manager
      # cheese # photo booth
      # eog # image viewer
      # evince # document viewer
      # file-roller # archive manager

      # these should be self explanatory
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      gnome-disk-utility
      gnome-characters
      pkgs.gnome-photos
      pkgs.gnome-connections
      # gnome-calculator
      # gnome-calendar
      # gnome-logs
      # gnome-screenshot
    ];
  };
}
