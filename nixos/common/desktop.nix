{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    # might disable on VMs or Servers
    enable = pkgs.libExt.mkEnabledOption "Desktop Configs";
    kde = pkgs.libExt.mkEnabledOption "KDE Desktop Environment";
    cosmic = pkgs.libExt.mkEnabledOption "Cosmic Desktop Environment";
  };

  config = lib.mkIf config.nixconf.desktop.enable {
    # Some tools use dconf to store settings
    programs.dconf.enable = true;

    # enable desktop portal
    xdg.portal.enable = true;

    services = {
      # Enable the X11
      xserver.enable = true;

      displayManager = {
        sddm.enable = config.nixconf.desktop.kde;
        cosmic-greeter.enable = !config.nixconf.desktop.kde && config.nixconf.desktop.cosmic;
      };

      desktopManager = {
        plasma6.enable = config.nixconf.desktop.kde;
        cosmic.enable = config.nixconf.desktop.cosmic;
      };
    };

    environment.systemPackages = [pkgs.xdg-utils];
  };
}
