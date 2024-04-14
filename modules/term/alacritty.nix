{
  pkgs,
  lib,
  config,
  ...
}: let
  genFontConf = type: {
    family = "${config.nixconf.font.mainFont} Nerd Font";
    style = type;
  };

  shell =
    if config.nixconf.term.tmux
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
        if config.nixconf.term.fish
        then {
          program = "fish";
          args = ["-l"];
        }
        else {
          program = "bash";
          args = ["-l"];
        }
      );
in {
  options.nixconf.term = {
    alacritty = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Alacritty";
    };
  };

  config = lib.mkIf config.nixconf.term.alacritty {
    home-manager.users.${config.nixconf.user} = {
      programs.alacritty = {
        enable = true;
        settings =
          {
            inherit shell;
            live_config_reload = true;
            cursor.style = "block";
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
            };
            font = {
              normal = genFontConf "Regular";
              bold = genFontConf "Bold";
              italic = genFontConf "Italic";
              bold_italic = genFontConf "Bold Italic";
              size = 12.0;
            };
          }
          // builtins.fromTOML (builtins.readFile
            (pkgs.fetchFromGitHub
              {
                owner = "catppuccin";
                repo = "alacritty";
                rev = "94800165c13998b600a9da9d29c330de9f28618e";
                sha256 = "Pi1Hicv3wPALGgqurdTzXEzJNx7vVh+8B9tlqhRpR2Y=";
              }
              + /catppuccin-mocha.toml));
      };
    };
  };
}
