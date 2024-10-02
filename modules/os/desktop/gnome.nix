{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop = {
    gnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Gnome desktop environment";
    };
  };

  config = lib.mkIf (config.nixconf.system.desktop.enable && config.nixconf.system.desktop.gnome) {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm = {
        enable = !config.nixconf.system.desktop.cosmic;
        wayland = !config.nixconf.system.desktop.cosmic;
      };
      desktopManager.gnome.enable = true;
    };

    # Packages
    environment.systemPackages = [
      pkgs.gnome-tweaks
    ];

    environment.gnome.excludePackages = [
      pkgs.baobab # disk usage analyzer
      pkgs.gnome-system-monitor
      pkgs.gnome-disk-utility
      pkgs.seahorse # password manager
      pkgs.epiphany # web browser
      pkgs.geary # email client
      pkgs.totem # video player
      pkgs.yelp # help viewer
      pkgs.simple-scan # document scanner
    ];
  };
}
