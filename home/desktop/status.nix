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
    status = mkBoolOption {description = "Enable i3status-rs config";};
  };

  config = lib.mkIf cfg.status {
    programs.i3status-rust = {
      enable = true;
      bars.default = {
        icons = "awesome6";
        settings = {
          theme = {
            theme = "dracula";
            overrides = {
              idle_bg = theme.base;
              idle_fg = theme.text;
              info_bg = theme.sky;
              info_fg = theme.base;
              good_bg = theme.green;
              good_fg = theme.base;
              warning_bg = theme.peach;
              warning_fg = theme.base;
              critical_bg = theme.red;
              critical_fg = theme.base;
            };
          };
        };
        blocks = [
          {block = "sound";}
          {
            block = "backlight";
            device = "intel_backlight";
            invert_icons = true;
          }
          {
            block = "battery";
            format = " $icon $percentage ";
            good = 60;
            info = 60;
            warning = 20;
            critical = 10;
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %d-%m-%Y %R') ";
          }
        ];
      };
    };
  };
}
