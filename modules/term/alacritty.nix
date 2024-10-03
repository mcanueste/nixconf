{
  lib,
  config,
  ...
}: let
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
    home-manager.users.${config.nixconf.os.user} = {
      programs.alacritty = {
        enable = true;
        settings = {
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
        };
      };
    };
  };
}
