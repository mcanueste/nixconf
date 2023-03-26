{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.zellij;
in {
  options.nixhome.zellij = {
    enable = mkBoolOption {description = "Enable zellij";};
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      settings = {
        shell = {
          program = "fish";
          # args = [
          #   "-l"
          #   "-c"
          #   "zellij attach || zellij"
          # ];
        };
      };
    };
    programs.zellij = {
      enable = true;
      settings = {
        theme = "catppuccin";
        pane_frames = false;
        default_mode = "locked";
        # default_layout = "compact";
        default_shell = "fish";
        themes = {
          catppuccin = {
            bg = "#585b70";
            fg = "#cdd6f4";
            red = "#f38ba8";
            green = "#a6e3a1";
            blue = "#89b4fa";
            yellow = "#f9e2af";
            magenta = "#f5c2e7";
            orange = "#fab387";
            cyan = "#89dceb";
            black = "#181825";
            white = "#cdd6f4";
          };
        };
      };
    };
  };
}
