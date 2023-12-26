{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    waybar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Waybar Config";
    };
  };

  config = lib.mkIf config.nixconf.desktop.waybar {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top"; # Waybar at top layer
          position = "top"; # Waybar position (top|bottom|left|right)
          height = 20; # Waybar height (to be removed for auto height)
          # width= 1280; # Waybar width
          spacing = 4; # Gaps between modules (4px)
          # Choose the order of the modules
          modules-left = ["sway/workspaces" "sway/mode"];
          # modules-center = ["custom/media"];
          modules-right = ["pulseaudio" "backlight" "battery" "sway/language" "clock" "tray"];
          # Modules configuration
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            warp-on-scroll = false;
            format = "{name}";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-muted = "󰝟 {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-source = " {volume}% ";
            format-source-muted = " ";
            format-icons = {
              headphone = "";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "${pkgs.pavucontrol}";
          };
          backlight = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };
          battery = {
            states = {
              warning = 20;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% 󰃨";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = ["" "" "" "" ""];
          };
          clock = {
            timezone = "Europe/Berlin";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          tray = {
            icon-size = 16;
            spacing = 6;
          };
        };
      };

      style = ''
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            font-size: 13px;
        }

        window#waybar {
            background-color: @base;
            border-bottom: 3px solid @surface0;
            color: @text;
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        button {
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each button name */
            border: none;
            border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
            background: inherit;
            box-shadow: inset 0 -3px @text;
        }

        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: @text;
        }

        #workspaces button:hover {
            background: @subtext1;
        }

        #workspaces button.focused {
            background-color: @surface0;
            box-shadow: inset 0 -3px @text;
        }

        #workspaces button.urgent {
            background-color: @red;
        }

        #mode {
            background-color: @base;
            border-bottom: 3px solid @text;
        }

        #clock,
        #battery,
        #backlight,
        #network,
        #pulseaudio,
        #tray,
        #mode {
            padding: 0 10px;
            color: @text;
        }

        #window,
        #workspaces {
            margin: 0 4px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        #clock {
            background-color: @base;
        }

        #battery {
            background-color: @base;
            color: @text;
        }

        #battery.charging, #battery.plugged {
            color: @green;
            background-color: @base;
        }

        @keyframes blink {
            to {
                background-color: @red;
                color: @base;
            }
        }

        #battery.critical:not(.charging) {
            background-color: @base;
            color: @red;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        label:focus {
            background-color: @base;
        }

        #backlight {
            background-color: @base;
        }

        #pulseaudio {
            background-color: @base;
            color: @text;
        }

        #pulseaudio.muted {
            background-color: @surface0;
            color: @peach;
        }

        #tray {
            background-color: @base;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: @red;
        }

        #language {
            background: @base;
            color: @text;
            padding: 0 5px;
            margin: 0 5px;
            min-width: 16px;
        }
      '';
    };
  };
}
