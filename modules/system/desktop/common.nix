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
    # enable dconf for gtk apps and gnome settings
    programs.dconf.enable = true;

    home-manager.users.${config.nixconf.system.user} = {
      # Enable gtk and qt config if desktop is enabled
      # Theme configuration is done in theme.nix
      gtk.enable = true;
      qt.enable = true;

      xdg = {
        enable = true;
        mime.enable = true;
        userDirs.enable = true;
      };

      home.packages = [
        pkgs.xdg-utils # for opening default programs when clicking links
      ];

      # NOTE: in case some gtk config is neeeded
      # dconf.settings = {
      #   "org/gnome/shell" = {
      #     disable-user-extensions = false;
      #     disabled-extensions = "disabled";
      #   };
      # };
    };
  };
}
