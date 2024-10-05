{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    alacritty = pkgs.libExt.mkEnabledOption "Alacritty";
  };

  config = let
    shell =
      if config.nixconf.term.tmux
      then {
        program = "bash";
        args = [
          "-l"
          "-c"
          "tmux attach || tmux"
        ];
      }
      else
        (
          if config.nixconf.shell.fish
          then {
            program = "fish";
            args = ["-l"];
          }
          else {
            program = "bash";
            args = ["-l"];
          }
        );

    getFont = font: style: {
      inherit style;
      family = "${font} Nerd Font";
    };
  in
    lib.mkIf config.nixconf.term.alacritty {
      programs.alacritty = {
        enable = true;
        catppuccin.enable = true;
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

          font = {
            normal = getFont config.nixconf.theme.font "Regular";
            bold = getFont config.nixconf.theme.font "Bold";
            italic = getFont config.nixconf.theme.font "Italic";
            bold_italic = getFont config.nixconf.theme.font "Bold Italic";
            size = 12.0;
          };
        };
      };
    };
}
