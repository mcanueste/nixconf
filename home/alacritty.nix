{ ... }:
{
  home-manager.users.mcst = {
    programs.alacritty = {
      enable = true;
      settings = {
        env = { # env variables
	  TERM = "xterm-256color";
	};
	window = {
	  padding = {
	    x = 6;
	    y = 6;
	  };
	  opacity = 0.90;
	  decorations = "none";
	  title = "Alacritty";
	  class = {
	    instance = "Alacritty";
	    general = "Alacritty";
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
        draw_bold_text_with_bright_colors = true;
        
        ### Ayu Mirage ###
	colors = {
	  cursor = {
            text = "#1b2b34";
            cursor = "#ffffff";
	  };
	  primary = {
            background = "#1f2430";
            foreground = "#cbccc6";
            bright_foreground = "#f28779";
	  };
	  normal = {
            black = "#212733";
            red = "#f08778";
            green = "#53bf97";
            yellow = "#fdcc60";
            blue = "#60b8d6";
            magenta = "#ec7171";
            cyan = "#98e6ca";
            white = "#fafafa";
	  };
	  bright = {
            black = "#686868";
            red = "#f58c7d";
            green = "#58c49c";
            yellow = "#ffd165";
            blue = "#65bddb";
            magenta = "#f17676";
            cyan = "#9debcf";
            white = "#ffffff";
	  };
	};

	visual_bell.duration = 0;
	dynamic_title = true;
        cursor.style = "block";
        # Render cursor as a hollow box when window is not focused.
        cursor.unfocused_hollow = true;
        live_config_reload = true;
	
	key_bindings = [
          { key = "V";         mods = "Control|Shift";  action = "Paste";            }
          { key = "C";         mods = "Control|Shift";  action = "Copy";             }
          { key = "Insert";    mods = "Shift";          action = "PasteSelection";   }
          { key = "Key0";      mods = "Control";        action = "ResetFontSize";    }
          { key = "Equals";    mods = "Control";        action = "IncreaseFontSize"; }
          { key = "Plus";      mods = "Control";        action = "IncreaseFontSize"; }
          { key = "Minus";     mods = "Control";        action = "DecreaseFontSize"; }
          { key = "F11";       mods = "None";           action = "ToggleFullscreen"; }
          { key = "Paste";     mods = "None";           action = "Paste";            }
          { key = "Copy";      mods = "None";           action = "Copy";             }
          { key = "L";         mods = "Control";        action = "ClearLogNotice";   }
          { key = "L";         mods = "Control";        chars  = "\x0c";             }
          { key = "PageUp";    mods = "None";           action = "ScrollPageUp";    mode = "~Alt"; }
          { key = "PageDown";  mods = "None";           action = "ScrollPageDown";  mode = "~Alt"; }
          { key = "Home";      mods = "Shift";          action = "ScrollToTop";     mode = "~Alt"; }
          { key = "End";       mods = "Shift";          action = "ScrollToBottom";  mode = "~Alt"; }
	];
      };
    };
  };
}
