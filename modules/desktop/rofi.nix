{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = import ./catppuccin.nix;
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
        font = "${config.nixconf.font.mainFont} Nerd Font 10";
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
        theme = with config.home-manager.users.${config.nixconf.user}.lib.formats.rasi; {
          "*" = {
            width = 600;
            bg-col = mkLiteral theme.base;
            bg-col-light = mkLiteral theme.base;
            border-col = mkLiteral theme.base;
            selected-col = mkLiteral theme.base;
            blue = mkLiteral theme.blue;
            fg-col = mkLiteral theme.text;
            fg-col2 = mkLiteral theme.red;
            grey = mkLiteral theme.overlay0;
          };
          element-text = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          element-icon = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          mode-switcher = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          window = {
            height = mkLiteral "360px";
            border = mkLiteral "3px";
            border-color = mkLiteral "@border-col";
            background-color = mkLiteral "@bg-col";
          };
          mainbox = {background-color = mkLiteral "@bg-col";};
          inputbar = {
            children = map mkLiteral ["prompt" "entry"];
            background-color = mkLiteral "@bg-col";
            border-radius = mkLiteral "5px";
            padding = mkLiteral "2px";
          };
          prompt = {
            background-color = mkLiteral "@blue";
            padding = mkLiteral "6px";
            text-color = mkLiteral "@bg-col";
            border-radius = mkLiteral "3px";
            margin = mkLiteral "20px 0px 0px 20px";
          };
          textbox-prompt-colon = {
            expand = false;
            str = ":";
          };
          entry = {
            padding = mkLiteral "6px";
            margin = mkLiteral "20px 0px 0px 10px";
            text-color = mkLiteral "@fg-col";
            background-color = mkLiteral "@bg-col";
          };
          listview = {
            border = mkLiteral "0px 0px 0px";
            padding = mkLiteral "6px 0px 0px";
            margin = mkLiteral "10px 0px 0px 20px";
            columns = 2;
            lines = 5;
            background-color = mkLiteral "@bg-col";
          };
          element = {
            padding = mkLiteral "5px";
            background-color = mkLiteral "@bg-col";
            text-color = mkLiteral "@fg-col";
          };
          element-icon = {size = mkLiteral "25px";};
          "element selected" = {
            background-color = mkLiteral "@selected-col";
            text-color = mkLiteral "@fg-col2";
          };
          mode-switcher = {spacing = 0;};
          button = {
            padding = mkLiteral "10px";
            background-color = mkLiteral "@bg-col-light";
            text-color = mkLiteral "@grey";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
          };
          "button selected" = {
            background-color = mkLiteral "@bg-col";
            text-color = mkLiteral "@blue";
          };
          message = {
            background-color = mkLiteral "@bg-col-light";
            margin = mkLiteral "2px";
            padding = mkLiteral "2px";
            border-radius = mkLiteral "5px";
          };
          textbox = {
            padding = mkLiteral "6px";
            margin = mkLiteral "20px 0px 0px 20px";
            text-color = mkLiteral "@blue";
            background-color = mkLiteral "@bg-col-light";
          };
        };
      };
    };
  };
}
