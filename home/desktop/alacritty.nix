{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;
      visual_bell.duration = 0;
      dynamic_title = true;
      cursor.style = "block";
      draw_bold_text_with_bright_colors = true;
      cursor.unfocused_hollow = true;
      env = {
        # env variables
        TERM = "xterm-256color";
      };
      window = {
        # opacity = 0.95;
        # decorations = "none";
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
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        size = 12.0;
      };

      # Rose Pine Theme
      colors = {
        primary = {
          background = "0x191724";
          foreground = "0xe0def4";
        };
        cursor = {
          text = "0xe0def4";
          cursor = "0x524f67";
        };
        vi_mode_cursor = {
          text = "0xe0def4";
          cursor = "0x524f67";
        };
        line_indicator = {
          foreground = null;
          background = null;
        };
        selection = {
          text = "0xe0def4";
          background = "0x403d52";
        };
        normal = {
          black = "0x26233a";
          red = "0xeb6f92";
          green = "0x31748f";
          yellow = "0xf6c177";
          blue = "0x9ccfd8";
          magenta = "0xc4a7e7";
          cyan = "0xebbcba";
          white = "0xe0def4";
        };
        bright = {
          black = "0x6e6a86";
          red = "0xeb6f92";
          green = "0x31748f";
          yellow = "0xf6c177";
          blue = "0x9ccfd8";
          magenta = "0xc4a7e7";
          cyan = "0xebbcba";
          white = "0xe0def4";
        };
        hints = {
          start = {
            foreground = "#908caa";
            background = "#1f1d2e";
          };
          end = {
            foreground = "#6e6a86";
            background = "#1f1d2e";
          };
        };
      };

      # Ayu Mirage Theme
      # colors = {
      #   cursor = {
      #     text = "#1b2b34";
      #     cursor = "#ffffff";
      #   };
      #   primary = {
      #     background = "#1f2430";
      #     foreground = "#cbccc6";
      #     bright_foreground = "#f28779";
      #   };
      #   normal = {
      #     black = "#212733";
      #     red = "#f08778";
      #     green = "#53bf97";
      #     yellow = "#fdcc60";
      #     blue = "#60b8d6";
      #     magenta = "#ec7171";
      #     cyan = "#98e6ca";
      #     white = "#fafafa";
      #   };
      #   bright = {
      #     black = "#686868";
      #     red = "#f58c7d";
      #     green = "#58c49c";
      #     yellow = "#ffd165";
      #     blue = "#65bddb";
      #     magenta = "#f17676";
      #     cyan = "#9debcf";
      #     white = "#ffffff";
      #   };
      # };
    };
  };
}
