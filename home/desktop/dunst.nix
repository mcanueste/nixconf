{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.desktop;
  theme = import ./catppuccin.nix;
in {
  options.nixhome.desktop = {
    dunst = mkBoolOption {description = "Enable dunst config";};
  };

  config = lib.mkIf cfg.dunst {
    services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.hicolor-icon-theme;
        name = "hicolor";
        size = "32x32";
      };
      settings = {
        global = {
          follow = "keyboard";
          mouse_left_click = "do_action";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
          notification_limit = 5;
          format = "<b> %a: %s </b> \\n\\n %b";
          font = "JetBrainsMono Nerd Font 10";
          frame_color = theme.blue;
          icon_position = "left";
          origin = "top-right";
          corner_radius = 6;
          frame_width = 2;
          padding = 15;
          width = 500;
          height = 200;
          timeout = 0;
          # offset = "${var.GAPSPX}x${builtins.toString (22 + lib.strings.toInt var.GAPSPX)}";
        };
        urgency_low = {
          background = theme.base;
          foreground = theme.text;
        };
        urgency_normal = {
          background = theme.base;
          foreground = theme.text;
        };
        urgency_critical = {
          background = theme.base;
          foreground = theme.text;
          frame_color = theme.peach;
        };
      };
    };
  };
}
