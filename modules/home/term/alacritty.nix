{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
  fontCfg = config.nixhome.font;

  shell =
    if cfg.tmux
    then {
      program = "dash";
      args = [
        "-l"
        "-c"
        "tmux attach || tmux"
      ];
    }
    else
      (
        if cfg.fish
        then {
          program = "fish";
          args = ["-l"];
        }
        else {
          program = "bash";
          args = ["-l"];
        }
      );

  genFontConf = type: {
    family = "${fontCfg.font} Nerd Font";
    style = type;
  };

  catppuccin-mocha = {
    primary = {
      background = "#1E1E2E";
      foreground = "#CDD6F4";
      dim_foreground = "#CDD6F4";
      bright_foreground = "#CDD6F4";
    };
    cursor = {
      text = "#1E1E2E";
      cursor = "#F5E0DC";
    };
    vi_mode_cursor = {
      text = "#1E1E2E";
      cursor = "#B4BEFE";
    };
    search = {
      matches = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
      focused_match = {
        foreground = "#1E1E2E";
        background = "#A6E3A1";
      };
      footer_bar = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
    };
    hints = {
      start = {
        foreground = "#1E1E2E";
        background = "#F9E2AF";
      };
      end = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
    };
    selection = {
      text = "#1E1E2E";
      background = "#F5E0DC";
    };
    normal = {
      black = "#45475A";
      red = "#F38BA8";
      green = "#A6E3A1";
      yellow = "#F9E2AF";
      blue = "#89B4FA";
      magenta = "#F5C2E7";
      cyan = "#94E2D5";
      white = "#BAC2DE";
    };
    bright = {
      black = "#585B70";
      red = "#F38BA8";
      green = "#A6E3A1";
      yellow = "#F9E2AF";
      blue = "#89B4FA";
      magenta = "#F5C2E7";
      cyan = "#94E2D5";
      white = "#A6ADC8";
    };
    dim = {
      black = "#45475A";
      red = "#F38BA8";
      green = "#A6E3A1";
      yellow = "#F9E2AF";
      blue = "#89B4FA";
      magenta = "#F5C2E7";
      cyan = "#94E2D5";
      white = "#BAC2DE";
    };
    indexed_colors = [
      {
        index = 16;
        color = "#FAB387";
      }
      {
        index = 17;
        color = "#F5E0DC";
      }
    ];
  };
in {
  options.nixhome.term = {
    alacritty = mkBoolOption {description = "Enable alacritty";};
  };

  config = lib.mkIf cfg.alacritty {
    programs.alacritty = {
      enable = true;
      settings = {
        inherit shell;
        live_config_reload = true;
        visual_bell.duration = 0;
        dynamic_title = true;
        cursor.style = "block";
        draw_bold_text_with_bright_colors = true;
        cursor.unfocused_hollow = true;
        env = {
          TERM = "xterm-256color";
        };
        window = {
          opacity = 1.0;
          decorations = "none";
          title = "Alacritty";
          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
          padding = {
            x = 6;
            y = 6;
          };
        };
        scrolling = {
          history = 50000;
          auto_scroll = false;
        };
        font = {
          normal = genFontConf "Regular";
          bold = genFontConf "Bold";
          italic = genFontConf "Italic";
          bold_italic = genFontConf "Bold Italic";
          size = 12.0;
        };
        colors = catppuccin-mocha;
        key_bindings = [
          {
            key = "H";
            mods = "Control|Shift";
            chars = "\\x1b[72;6u";
          }
          {
            key = "J";
            mods = "Control|Shift";
            chars = "\\x1b[74;6u";
          }
          {
            key = "K";
            mods = "Control|Shift";
            chars = "\\x1b[75;6u";
          }
          {
            key = "L";
            mods = "Control|Shift";
            chars = "\\x1b[76;6u";
          }
        ];
      };
    };
  };
}
