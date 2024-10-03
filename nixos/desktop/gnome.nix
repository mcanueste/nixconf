{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop.gnome = lib.mkEnableOption "Gnome desktop environment";

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.gnome) {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Gnome Display Manager
      displayManager.gdm = {
        enable = !config.nixconf.desktop.cosmic;
        wayland = !config.nixconf.desktop.cosmic;
      };

      # Gnome Desktop Manager
      desktopManager.gnome.enable = true;
    };

    # Gnome uses Dconf for Gnome settings
    programs.dconf.enable = true;

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
