{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = import ./catppuccin.nix;
in {
  options.nixconf.desktop = {
    sway = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Sway WM Config";
    };
  };

  config = lib.mkIf config.nixconf.desktop.sway {
    # screenshot apps
    home.packages = [
      pkgs.grim
      pkgs.slurp
      pkgs.swappy
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["pink"];
          variant = "mocha";
        };
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        workspaceAutoBackAndForth = true;
        defaultWorkspace = "workspace number 1";
        menu = "${pkgs.wofi}/bin/wofi";
        bars = [{command = "${pkgs.waybar}/bin/waybar";}];
        input = {
          "*" = {
            xkb_layout = "us,de";
            xkb_model = "pc105";
            xkb_options = "caps:escape,grp:win_space_toggle";
          };
        };
        window = {
          titlebar = false;
          border = 2;
        };
        floating = {
          titlebar = false;
          border = 2;
        };
        focus = {
          newWindow = "smart";
          followMouse = true;
          mouseWarping = false;
        };
        fonts = {
          names = ["JetBrainsMono Nerd Font"];
        };
        gaps = {
          smartGaps = false;
          inner = 8;
          outer = -2;
        };
        colors = {
          background = theme.base;
          focused = {
            border = theme.sky;
            background = theme.base;
            inherit (theme) text;
            indicator = theme.teal;
            childBorder = theme.blue;
          };
          focusedInactive = {
            border = theme.mauve;
            background = theme.base;
            inherit (theme) text;
            indicator = theme.rosewater;
            childBorder = theme.flamingo;
          };
          unfocused = {
            border = theme.mauve;
            background = theme.base;
            inherit (theme) text;
            indicator = theme.rosewater;
            childBorder = theme.flamingo;
          };
          urgent = {
            border = theme.peach;
            background = theme.base;
            inherit (theme) text;
            indicator = theme.overlay0;
            childBorder = theme.peach;
          };
          placeholder = {
            border = theme.overlay0;
            background = theme.base;
            inherit (theme) text;
            indicator = theme.overlay0;
            childBorder = theme.overlay0;
          };
        };
        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+r" = "reload";

          # launcher
          "${modifier}+d" = "exec rofi -show drun";
          "${modifier}+p" = "exec rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";

          # move/focus window
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # layout
          "${modifier}+w" = "layout toggle split";
          "${modifier}+v" = "split h";
          "${modifier}+s" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+Shift+f" = "floating toggle";
          "${modifier}+g" = "focus mode_toggle";

          # workspace
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "${modifier}+o" = "workspace back_and_forth";
          "${modifier}+Alt+h" = "workspace prev";
          "${modifier}+Alt+l" = "workspace next";
          "${modifier}+Alt+Shift+h" = "move workspace to output left";
          "${modifier}+Alt+Shift+j" = "move workspace to output down";
          "${modifier}+Alt+Shift+k" = "move workspace to output up";
          "${modifier}+Alt+Shift+l" = "move workspace to output right";

          # shortcuts
          "${modifier}+b" = "exec brave";
          "${modifier}+n" = "exec obsidian ~/notes";
          "${modifier}+z" = "exec obsidian ~/german";
          "${modifier}+c" = "exec discord";

          ## Output pressed keycode using xev:
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --unmute --decrease 5";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --unmute --increase 5";
          "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          # XF86Display
          # XF86WLAN
          # XF86Tools
          # XF86Search
          # XF86LaunchA
          # XF86Explorer
          # "XF86Calculator" = "exec ${pkgs.gnome.gnome-calculator}/bin/gnome-calculator";
          # "XF86???Lock" = "";
          # "XF86HomePage" = "exec ${pkgs.firefox-wayland}/bin/firefox";
          # "XF86???FOLDER" = "";

          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -s previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -s next";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -s play-pause";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl -s stop";
          "Control+XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -s position 30-";
          "Control+XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -s position 30+";
          "Control+XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -s stop";

          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Do you want to exit?' -b 'Yes' 'swaymsg exit'";
          "${modifier}+Escape" = "exec ${pkgs.swaylock}/bin/swaylock";

          # Screenshot
          "Print" = ''exec grim -g "$(slurp)" $HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png'';
          "Shift+Print" = ''exec grim -g "$(slurp)" - | swappy -o $HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png -f -'';

          ## Screen recording
          # "${modifier}+Print" = "exec wayrecorder --notify screen";
          # "${modifier}+Shift+Print" = "exec wayrecorder --notify --input area";
          # "${modifier}+Alt+Print" = "exec wayrecorder --notify --input active";
          # "${modifier}+Shift+Alt+Print" = "exec wayrecorder --notify --input window";
          # "${modifier}+Ctrl+Print" = "exec wayrecorder --notify --clipboard --input screen";
          # "${modifier}+Ctrl+Shift+Print" = "exec wayrecorder --notify --clipboard --input area";
          # "${modifier}+Ctrl+Alt+Print" = "exec wayrecorder --notify --clipboard --input active";
          # "${modifier}+Ctrl+Shift+Alt+Print" = "exec wayrecorder --notify --clipboard --input window";

          "${modifier}+r" = "mode resize";
        };
        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
        output = {"*" = {bg = "${./wallpaper.png} fill";};};
        startup = [
          {
            command = "${pkgs.blueman}/bin/blueman-applet";
            always = true;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            always = true;
          }
        ];
      };
    };
  };
}
