{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = pkgs.catppuccin.override {
    accent = "sky";
    variant = "mocha";
    themeList = ["waybar"];
  };
in {
  options.nixconf.system.desktop = {
    waybar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Waybar";
    };
  };

  config = lib.mkIf (config.nixconf.system.desktop.enable && config.nixconf.system.desktop.waybar) {
    home-manager.users.${config.nixconf.user} = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top"; # Waybar at top layer
            position = "top"; # Waybar position (top|bottom|left|right)
            height = 28; # Waybar height (to be removed for auto height)
            spacing = 4; # Gaps between modules (4px)
            modules-left = ["hyprland/workspaces"];
            modules-center = ["clock"]; # "custom/media"
            modules-right = ["hyprland/language" "pulseaudio" "backlight" "cpu" "memory" "battery" "tray"];
            # Modules configuration
            "hyprland/workspaces" = {
              all-outputs = true;
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
              # on-click = "${pkgs.pavucontrol}";
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
              format = "{:%H:%M - %d.%m.%Y}";
              format-alt = "{:%H:%M - %d.%m.%Y}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };
            cpu = {
              interval = 10;
              format = "{usage}% ";
              max-length = 10;
            };
            memory = {
              interval = 30;
              format = "{percentage}% ";
              max-length = 10;
            };
            tray = {
              icon-size = 16;
              spacing = 6;
            };
          };
        };

        style = ''
          @import "${theme}/waybar/mocha.css";

          * {
              /* `otf-font-awesome` is required to be installed for icons */
              font-family: ${config.nixconf.font.mainFont}, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
              font-size: 14px;
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

          #workspaces button.active {
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
          #cpu,
          #memory,
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
  };
}
