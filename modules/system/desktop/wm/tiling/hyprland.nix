{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.wm.tiling = {
    hyprland = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland";
    };
  };

  config =
    lib.mkIf (
      config.nixconf.system.desktop.enable
      && config.nixconf.system.desktop.wm.enable
      && config.nixconf.system.desktop.wm.tiling.hyprland
    ) {
      # To make some apps work properly on wayland and hyprland
      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";

        # For GTK apps
        GTK_USE_PORTAL = "1";

        # QT configs
        # QT_QPA_PLATFORM = "wayland"; defined by default with nixos modules
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        # for gnome apps if we ever use one
        # defined by nixos modules by default
        # GDK_BACKEND = "wayland,x11";

        # For SDL library
        SDL_VIDEODRIVER = "wayland";

        # electron apps
        NIXOS_OZONE_WL = "1";

        # For some java apps
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # For firefox
        MOZ_ENABLE_WAYLAND = "1";
      };

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      home-manager.users.${config.nixconf.system.user} = {
        # Screen share doesn't work properly...
        # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
        # https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580
        # https://wiki.hyprland.org/Useful-Utilities/xdg-desktop-portal-hyprland/
        home.packages = lib.lists.flatten [
          # Wallpaper
          pkgs.swaybg # TODO maybe change to hyprpaper later

          # Screenshot
          pkgs.swappy
          pkgs.grimblast

          # Utils
          pkgs.udiskie
          pkgs.wl-clipboard
          pkgs.cliphist
          pkgs.hyprlock
          # TODO: setup hyprlock properly
          # TODO: add hypr picker in the future
          # TODO: add hypr idle in the future
          # TODO: add hypr cursor in the future
          # TODO: wtf hyprland-protocols?
        ];

        wayland.windowManager.hyprland = {
          enable = true;

          systemd.variables = [
            "DISPLAY"
            "HYPRLAND_INSTANCE_SIGNATURE"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_DESKTOP"
            "XDG_SESSION_TYPE"
            "GTK_USE_PORTAL"
            "QT_QPA_PLATFORM"
            "QT_QPA_PLATFORMTHEME"
            "QT_STYLE_OVERRIDE"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION"
            "QT_AUTO_SCREEN_SCALE_FACTOR"
            "GDK_BACKEND"
            "SDL_VIDEODRIVER"
            "NIXOS_OZONE_WL"
            "_JAVA_AWT_WM_NONREPARENTING"
            "MOZ_ENABLE_WAYLAND"
          ];

          settings = {
            # Auto scale to multiple monitors with priority to resolution
            monitor = ",highres,auto,1";

            general = {
              gaps_in = 8;
              gaps_out = 0;
              border_size = 2;
              layout = "dwindle";
              # no_cursor_warps = true;
              resize_on_border = true;
              # If latency and jitter in games: https://wiki.hyprland.org/Configuring/Tearing/
              allow_tearing = false;
              "col.active_border" = "$sky";
              "col.inactive_border" = "$mauve";
            };

            decoration = {
              rounding = 5;
              drop_shadow = true;
              shadow_range = 8;
              shadow_render_power = 2;
              "col.shadow" = "$mantle";
              "col.shadow_inactive" = "$base";
              blur = {
                enabled = false;
              };
            };

            animations = {
              enabled = true;
              bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
              animation = [
                "windows, 1, 7, myBezier"
                "windowsOut, 1, 7, default, popin 80%"
                "border, 1, 10, default"
                "borderangle, 1, 8, default"
                "fade, 1, 7, default"
                "workspaces, 1, 6, default"
              ];
            };

            input = {
              kb_layout = "us,de";
              kb_model = "pc105";
              kb_options = "caps:escape,grp:win_space_toggle";
              follow_mouse = 1;
              numlock_by_default = true;
              touchpad = {
                disable_while_typing = true;
                natural_scroll = 1;
              };
              sensitivity = 0;
            };

            dwindle = {
              pseudotile = true;
              preserve_split = true;
            };

            master = {
              new_is_master = true;
            };

            gestures = {
              workspace_swipe = true;
            };

            misc = {
              force_default_wallpaper = 0;
              animate_manual_resizes = true;
              animate_mouse_windowdragging = true; # can cause weird behavior on curves
            };

            windowrule = [
              "float, ^(gnome-calculator)$"
              "float, ^(Color Picker)$"
            ];

            windowrulev2 = [
              "opacity 0.0 override,class:^(xwaylandvideobridge)$"
              "noanim,class:^(xwaylandvideobridge)$"
              "noinitialfocus,class:^(xwaylandvideobridge)$"
              "maxsize 1 1,class:^(xwaylandvideobridge)$"
              "noblur,class:^(xwaylandvideobridge)$"
            ];

            exec-once = [
              # "swaybg -m fill -i ${../../wallpaper.png} &"
              "swaybg -m fill -i ${../../wallpaper.jpg} &"
              "waybar &"
              "swaync &"
              "udiskie &"
              "xwaylandvideobridge &"
              "wl-paste --type text --watch cliphist store &" # store text data
              "wl-paste --type image --watch cliphist store &" # store image data
            ];

            "$mod" = "SUPER";

            bind = [
              #### WM Specific

              "$mod SHIFT, r, exec, hyprctl reload,"
              "$mod SHIFT, q, killactive,"
              "$mod SHIFT, e, exit,"
              "$mod SHIFT, p, pseudo," # toggle pseudotiling: keep floating size when tiled

              "$mod, w, togglesplit,"
              "$mod, f, fullscreen,"
              "$mod SHIFT, f, togglefloating,"

              "$mod, h, movefocus, l"
              "$mod, j, movefocus, d"
              "$mod, k, movefocus, u"
              "$mod, l, movefocus, r"

              "$mod SHIFT, h, movewindow, l"
              "$mod SHIFT, j, movewindow, d"
              "$mod SHIFT, k, movewindow, u"
              "$mod SHIFT, l, movewindow, r"

              "$mod, 1, workspace, 1"
              "$mod, 2, workspace, 2"
              "$mod, 3, workspace, 3"
              "$mod, 4, workspace, 4"
              "$mod, 5, workspace, 5"
              "$mod, 6, workspace, 6"
              "$mod, 7, workspace, 7"
              "$mod, 8, workspace, 8"
              "$mod, 9, workspace, 9"
              "$mod, 0, workspace, 0"

              "$mod SHIFT, 1, movetoworkspace, 1"
              "$mod SHIFT, 2, movetoworkspace, 2"
              "$mod SHIFT, 3, movetoworkspace, 3"
              "$mod SHIFT, 4, movetoworkspace, 4"
              "$mod SHIFT, 5, movetoworkspace, 5"
              "$mod SHIFT, 6, movetoworkspace, 6"
              "$mod SHIFT, 7, movetoworkspace, 7"
              "$mod SHIFT, 8, movetoworkspace, 8"
              "$mod SHIFT, 9, movetoworkspace, 9"
              "$mod SHIFT, 0, movetoworkspace, 0"

              "$mod ALT, h, focusmonitor, m-1"
              "$mod ALT, l, focusmonitor, m+1"
              "$mod ALT SHIFT, h, movecurrentworkspacetomonitor, m-1"
              "$mod ALT SHIFT, l, movecurrentworkspacetomonitor, m+1"

              # Launch
              "$mod, RETURN, exec, alacritty"
              "$mod, b, exec, brave"
              "$mod, o, exec, obsidian"
              "$mod, t, exec, thunar"
              "$mod, d, exec, rofi -show drun"
              "$mod, s, exec, rofi -show run"
              "$mod, p, exec, rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu"
              "$mod, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
              "$mod, n, exec, swaync-client -t"
              "$mod SHIFT, n, exec, swaync-client -C"

              ", Print, exec, grimblast --notify save area"
              "CTRL, Print, exec, grimblast --notify save active"
              "ALT, Print, exec, grimblast --notify save output"
              "SHIFT, Print, exec, swappy -o $HOME/Pictures/Edited/$(date -u +'%Y%m%d-%H%M%SZ').png -f $(grimblast --notify save area)"
              "CTRL SHIFT, Print, exec, swappy -o $HOME/Pictures/Edited/$(date -u +'%Y%m%d-%H%M%SZ').png -f $(grimblast --notify save active)"
              "ALT SHIFT, Print, exec, swappy -o $HOME/Pictures/Edited/$(date -u +'%Y%m%d-%H%M%SZ').png -f $(grimblast --notify save output)"

              ", XF86Calculator, exec, galculator"

              # ## Screen recording
              # "${modifier}+Print" = "exec wayrecorder --notify screen";
              # "${modifier}+Shift+Print" = "exec wayrecorder --notify --input area";
              # "${modifier}+Alt+Print" = "exec wayrecorder --notify --input active";
              # "${modifier}+Shift+Alt+Print" = "exec wayrecorder --notify --input window";
              # "${modifier}+Ctrl+Print" = "exec wayrecorder --notify --clipboard --input screen";
              # "${modifier}+Ctrl+Shift+Print" = "exec wayrecorder --notify --clipboard --input area";
              # "${modifier}+Ctrl+Alt+Print" = "exec wayrecorder --notify --clipboard --input active";
              # "${modifier}+Ctrl+Shift+Alt+Print" = "exec wayrecorder --notify --clipboard --input window";
            ];

            bindm = [
              # Move/resize windows with mainMod + LMB/RMB and dragging
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            binde = [
              # Sound buttons
              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ", XF86AudioPrev, exec, playerctl -s previous"
              ", XF86AudioNext, exec, playerctl -s next"
              ", XF86AudioPlay, exec, playerctl -s play-pause"
              ", XF86AudioStop, exec, playerctl -s stop"
              "CONTROL, XF86AudioPrev, exec, playerctl -s position 30-"
              "CONTROL, XF86AudioNext, exec, playerctl -s position 30+"
              "CONTROL, XF86AudioPlay, exec, playerctl -s stop"

              # Brightness buttons
              ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
              ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ];
          };

          extraConfig = ''
            # window resize
            bind = $mod, r, submap, resize
            submap = resize
            binde = , l, resizeactive, 10 0
            binde = , h, resizeactive, -10 0
            binde = , k, resizeactive, 0 -10
            binde = , j, resizeactive, 0 10
            bind = , escape, submap, reset
            submap = reset
          '';
        };
      };
    };
}
