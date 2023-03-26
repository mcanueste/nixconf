{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.i3;

  catppuccin = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
in {
  options.nixhome.i3 = {
    enable = mkBoolOption {description = "Enable i3 config";};
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        workspaceAutoBackAndForth = true;
        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          "${modifier}+Escape" = "exec ${pkgs.i3lock}/bin/i3lock --color 000000";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # layout
          "${modifier}+v" = "split h";
          "${modifier}+s" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+Shift+s" = "layout toggle split";
          # "${modifier}+Shift+space" = "floating toggle"; TODO
          # "${modifier}+space" = "focus mode_toggle";
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

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
          "${modifier}+a" = "workspace back_and_forth";
          "${modifier}+Ctrl+h" = "workspace prev";
          "${modifier}+Ctrl+l" = "workspace next";
          "${modifier}+Ctrl+Shift+h" = "move workspace to output left";
          "${modifier}+Ctrl+Shift+j" = "move workspace to output down";
          "${modifier}+Ctrl+Shift+k" = "move workspace to output up";
          "${modifier}+Ctrl+Shift+l" = "move workspace to output right";

          ## Output pressed keycode using xev:
          ## nix-shell -p xorg.xev --run "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --unmute --decrease 5";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --unmute --increase 5";
          "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          ## XF86Display
          ## XF86WLAN
          ## XF86Tools
          ## XF86Search
          ## XF86LaunchA
          ## XF86Explorer
          "XF86Calculator" = "exec ${pkgs.gnome.gnome-calculator}/bin/gnome-calculator";
          # "XF86???Lock" = "";
          # "XF86HomePage" = "exec ${pkgs.firefox-wayland}/bin/firefox";
          # "XF86???FOLDER" = "";

          ## Screenshot
          "Print" = ''exec --no-startup-id ${pkgs.maim}/bin/maim "$HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png"'';
          "Shift+Print" = ''exec --no-startup-id ${pkgs.maim}/bin/maim --select "$HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png"'';
          # "Alt+Print" = ''exec --no-startup-id ${pkgs.maim}/bin/maim --window $(${pkgs.xdotool}/bin/xdotool getactivewindow) "$HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png"'';
          "Ctrl+Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
          "Ctrl+Shift+Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim --select | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
          # "Ctrl+Alt+Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim --window $(${pkgs.xdotool}/bin/xdotool getactivewindow) | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";

          ## Screen recording
          # "${modifier}+Print" = "exec wayrecorder --notify screen";
          # "${modifier}+Shift+Print" = "exec wayrecorder --notify --input area";
          # "${modifier}+Alt+Print" = "exec wayrecorder --notify --input active";
          # "${modifier}+Shift+Alt+Print" = "exec wayrecorder --notify --input window";
          # "${modifier}+Ctrl+Print" = "exec wayrecorder --notify --clipboard --input screen";
          # "${modifier}+Ctrl+Shift+Print" = "exec wayrecorder --notify --clipboard --input area";
          # "${modifier}+Ctrl+Alt+Print" = "exec wayrecorder --notify --clipboard --input active";
          # "${modifier}+Ctrl+Shift+Alt+Print" = "exec wayrecorder --notify --clipboard --input window";

          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -s previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -s next";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -s play-pause";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl -s stop";
          "Control+XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -s position 30-";
          "Control+XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -s position 30+";
          "Control+XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -s stop";

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
          smartGaps = true;
          inner = 6;
          outer = -2;
        };
        colors = {
          background = catppuccin.base;
          focused = {
            border = catppuccin.sky;
            background = catppuccin.base;
            inherit (catppuccin) text;
            indicator = catppuccin.teal;
            childBorder = catppuccin.blue;
          };
          focusedInactive = {
            border = catppuccin.mauve;
            background = catppuccin.base;
            inherit (catppuccin) text;
            indicator = catppuccin.rosewater;
            childBorder = catppuccin.flamingo;
          };
          unfocused = {
            border = catppuccin.mauve;
            background = catppuccin.base;
            inherit (catppuccin) text;
            indicator = catppuccin.rosewater;
            childBorder = catppuccin.flamingo;
          };
          urgent = {
            border = catppuccin.peach;
            background = catppuccin.base;
            inherit (catppuccin) text;
            indicator = catppuccin.overlay0;
            childBorder = catppuccin.peach;
          };
          placeholder = {
            border = catppuccin.overlay0;
            background = catppuccin.base;
            inherit (catppuccin) text;
            indicator = catppuccin.overlay0;
            childBorder = catppuccin.overlay0;
          };
        };
        bars = [
          {
            mode = "dock";
            hiddenState = "hide";
            position = "top";
            trayOutput = "primary";
            workspaceButtons = true;
            workspaceNumbers = true;
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            fonts = {
              names = ["JetBrainsMono Nerd Font"];
              size = 8.0;
            };
            colors = {
              background = catppuccin.base;
              statusline = catppuccin.sky;
              separator = catppuccin.mauve;
              focusedWorkspace = {
                border = catppuccin.sky;
                background = catppuccin.base;
                inherit (catppuccin) text;
              };
              activeWorkspace = {
                border = catppuccin.mauve;
                background = catppuccin.base;
                inherit (catppuccin) text;
              };
              inactiveWorkspace = {
                border = catppuccin.mauve;
                background = catppuccin.base;
                inherit (catppuccin) text;
              };
              urgentWorkspace = {
                border = catppuccin.peach;
                background = catppuccin.base;
                text = catppuccin.peach;
              };
              bindingMode = {
                border = catppuccin.rosewater;
                background = catppuccin.base;
                inherit (catppuccin) text;
              };
            };
          }
        ];
        startup = [
          {
            command = "${pkgs.feh}/bin/feh --bg-fill ${./wallpaper.png}";
            always = true;
            notification = false;
          }
        ];
      };
    };

    programs.i3status-rust = {
      enable = true;
      bars.default = {
        icons = "awesome6";
        # theme = "dracula";
        settings = {
          theme = {
            theme = "dracula";
            overrides = {
              idle_bg = catppuccin.base;
              idle_fg = catppuccin.text;
              info_bg = catppuccin.sky;
              info_fg = catppuccin.base;
              good_bg = catppuccin.green;
              good_fg = catppuccin.base;
              warning_bg = catppuccin.peach;
              warning_fg = catppuccin.base;
              critical_bg = catppuccin.red;
              critical_fg = catppuccin.base;
              # separator = "\ue0b2";
              # separator_bg = "auto";
              # separator_fg = "auto";
            };
          };
        };
        blocks = [
          {
            block = "load";
            interval = 1;
            format = " $icon  $1m.eng(w:4) ";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:1) ";
            format_alt = " $icon_swap $swap_free.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) ";
            interval = 10;
            warning_mem = 70;
            critical_mem = 90;
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {block = "sound";}
          {
            block = "backlight";
            device = "intel_backlight";
            invert_icons = true;
          }
          {
            block = "battery";
            format = " $icon $percentage ";
            good = 60;
            info = 60;
            warning = 20;
            critical = 10;
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %d-%m-%Y %R') ";
          }
        ];
      };
    };

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 12;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };
  };
}
