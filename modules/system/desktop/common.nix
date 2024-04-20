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
      # TODO: configure if mime needs to be configured
      mime.enable = true;
      icons.enable = true;
      menus.enable = true;
      sounds.enable = true;
      autostart.enable = true;

      portal = {
        enable = true;

        # Sets environment variable `GTK_USE_PORTAL` to `1`.
        # This will force GTK-based programs ran outside Flatpak to respect and use XDG Desktop Portals
        # for features like file chooser but it is an unsupported hack that can easily break things.
        # Defaults to `false` to respect its opt-in nature.
        gtkUsePortal = true;

        # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
        # This will make `xdg-open` use the portal to open programs, which resolves bugs involving
        # programs opening inside FHS envs or with unexpected env vars set from wrappers.
        xdgOpenUsePortal = true;

        extraPortals = [
          pkgs.xdg-desktop-portal
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };

    home-manager.users.${config.nixconf.user} = {
      # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/4
      # https://github.com/catppuccin/nix
      qt = {
        enable = true;
        platformTheme = "gtk";
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
