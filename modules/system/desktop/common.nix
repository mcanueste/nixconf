{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop configs.";
    };
  };

  config = lib.mkIf config.nixconf.system.desktop.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils # for opening default programs when clicking links
    ];

    xdg = {
      mime.enable = true;
      icons.enable = true;
      menus.enable = true;
      sounds.enable = true;
      autostart.enable = true;

      portal = {
        enable = true;

        # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
        # This will make `xdg-open` use the portal to open programs, which resolves bugs involving
        # programs opening inside FHS envs or with unexpected env vars set from wrappers.
        xdgOpenUsePortal = true;

        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };

    home-manager.users.${config.nixconf.user} = {
      xdg = {
        enable = true;
        mime.enable = true;
        userDirs.enable = true;

        portal = {
          enable = true;

          # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
          # This will make `xdg-open` use the portal to open programs, which resolves bugs involving
          # programs opening inside FHS envs or with unexpected env vars set from wrappers.
          xdgOpenUsePortal = true;

          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];

          # xdg-desktop-portal 1.17 reworked how portal implementations are loaded,
          # you should either set `xdg.portal.config` or `xdg.portal.configPackages`
          # to specify which portal backend to use for the requested interface.
          #
          # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in
          #
          # If you simply want to keep the behaviour in < 1.17, which uses the first
          # portal implementation found in lexicographical order, use the following:
          #
          # xdg.portal.config.common.default = "*";
          config.common.default = "*";
        };
      };

      # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/4
      # https://github.com/catppuccin/nix
      qt = {
        enable = true;
        platformTheme.name = "gtk";
        style = {
          name = "gtk2";
          # TODO How is the catppuccin theme setup for this?
          # package = pkgs.catppuccin.override {
          #   accent = "sky";
          #   variant = "mocha";
          #   themeList = ["qt5ct"];
          # } + /qt5ct/Catppuccin-Mocha.conf;
        };
      };

      # TODO fix these theming configs later
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
  };
}
