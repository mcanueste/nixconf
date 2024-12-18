{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    # might disable on VMs or Servers
    enable = pkgs.libExt.mkEnabledOption "Desktop Configs";
    gnome = pkgs.libExt.mkEnabledOption "Gnome Desktop Environment";
    cosmic = pkgs.libExt.mkEnabledOption "Cosmic Desktop Environment";
  };

  config = lib.mkIf config.nixconf.desktop.enable {
    # Gnome uses Dconf for Gnome settings and some other tools
    programs.dconf.enable = true;

    # enable desktop portal
    xdg.portal.enable = true;

    services = {
      xserver = {
        # Enable the X11 in case we need it.
        enable = true;

        displayManager.gdm = {
          enable = config.nixconf.desktop.gnome;
          wayland = config.nixconf.desktop.gnome;
        };

        desktopManager.gnome.enable = config.nixconf.desktop.gnome;
      };

      displayManager.cosmic-greeter.enable = !config.nixconf.desktop.gnome && config.nixconf.desktop.cosmic;
      desktopManager.cosmic.enable = config.nixconf.desktop.cosmic;
    };

    environment.systemPackages =
      [pkgs.xdg-utils]
      ++ (
        if config.nixconf.desktop.gnome
        then [
          pkgs.gnome-tweaks
        ]
        else []
      );
  };
}
