{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = pkgs.catppuccin.override {
    accent = "sky";
    variant = "mocha";
    themeList = ["rofi"];
  };
in {
  options.nixconf.desktop = {
    rofi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Rofi";
    };
  };

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.rofi) {
    home-manager.users.${config.nixconf.user} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = "${config.nixconf.font.mainFont} Nerd Font 14";
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
        theme = "${theme}/rofi/catppuccin-mocha.rasi";
      };
    };
  };
}
