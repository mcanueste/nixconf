{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    swaync = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Sway Notification Center Config";
    };
  };

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.swaync) {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        pkgs.swaynotificationcenter
        pkgs.libnotify
      ];

      xdg.configFile."swaync/style.css".text =
        lib.strings.replaceStrings ["Ubuntu"] [config.nixconf.font.mainFont]
        (builtins.readFile (pkgs.fetchurl {
          url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/mocha.css";
          sha256 = "sha256-2263JSGJLu2HyHQRsFt14NSFfYj0t3h52KoE3fYL5Kc=";
        }));
    };
  };
}
