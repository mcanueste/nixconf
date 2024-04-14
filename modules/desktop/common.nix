{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable desktop configs.";
    };
  };

  config = lib.mkIf config.nixconf.desktop.enable {
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      GTK_USE_PORTAL = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        # pkgs.xdg-desktop-portal-hyprland
      ];
    };

    home-manager.users.${config.nixconf.user} = {
      qt = {
        # TODO: properly configure to be catppuccin theme
        enable = true;
        platformTheme = "gtk";
        style = {
          name = "adwaita-dark";
          package = pkgs.catppuccin.override {
            accent = "sky";
            variant = "mocha";
          };
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-Mocha-Compact-Sky-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = ["sky"];
            variant = "mocha";
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "macOS-Monterey-White";
          package = pkgs.apple-cursor;
        };
      };
    };

    # Tumbler is a D-Bus service for applications to request thumbnails
    # for various URI schemes and MIME types.
    services.tumbler.enable = true;

    # Enable thunar file manager and other services for automated mounts etc.
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    environment.systemPackages = with pkgs; [
      wdisplays # tool to configure displays
      xdg-utils # for opening default programs when clicking links
      glib # gsettings
    ];
  };
}
