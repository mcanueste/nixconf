{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.wm.notification = {
    swaync = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Sway Notification Center Config";
    };
  };

  config =
    lib.mkIf (
      config.nixconf.system.desktop.enable
      && config.nixconf.system.desktop.wm.enable
      && config.nixconf.system.desktop.wm.notification.swaync
    ) {
      home-manager.users.${config.nixconf.user} = {
        home.packages = lib.lists.flatten [
          pkgs.swaynotificationcenter
          pkgs.libnotify
        ];
      };
    };
}
