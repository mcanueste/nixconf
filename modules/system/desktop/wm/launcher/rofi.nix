{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.wm.launcher = {
    rofi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Rofi";
    };
  };

  config =
    lib.mkIf (
      config.nixconf.system.desktop.enable
      && config.nixconf.system.desktop.wm.enable
      && config.nixconf.system.desktop.wm.launcher.rofi
    ) {
      home-manager.users.${config.nixconf.system.user} = {
        programs.rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          terminal = "alacritty";
          extraConfig = {
            modi = "run,drun";
            show-icons = true;
            sidebar-mode = true;
            hide-scrollbar = true;
            disable-history = false;
            icon-theme = "Oranchelo";
            display-run = "   Run ";
            display-drun = "   Apps ";
            display-window = " 﩯  Window";
            drun-display-format = "{icon} {name}";
          };
        };
      };
    };
}
