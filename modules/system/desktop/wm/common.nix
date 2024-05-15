{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.wm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable window-manager configs.";
    };

    blueman = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable blueman.";
    };

    networkmanager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable network-manager-applet.";
    };

    kanshi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kanshi for screen configurations.";
    };

    kanshiTarget = lib.mkOption {
      type = lib.types.str;
      default = "hyprland-session.target";
      description = "Systemd target for kanshi.";
    };
  };

  config =
    lib.mkIf (
      config.nixconf.system.desktop.enable
      && config.nixconf.system.desktop.wm.enable
    ) {
      environment.systemPackages = [
        pkgs.wdisplays # tool to configure displays
        pkgs.xwaylandvideobridge # for fixing screen share on x apps
      ];

      home-manager.users.${config.nixconf.system.user} = {
        home.packages = [
          pkgs.playerctl # media player control
          pkgs.brightnessctl # backlight control
          pkgs.pamixer # in case xorg is used (in wireplumber: wpctl)
          pkgs.pavucontrol # pulseaudio volume control
          pkgs.kanshi # auto display configuration tool
          pkgs.udiskie # automount
        ];

        services = {
          blueman-applet.enable = config.nixconf.system.desktop.wm.blueman;
          network-manager-applet.enable = config.nixconf.system.desktop.wm.networkmanager;

          kanshi = {
            enable = config.nixconf.system.desktop.wm.kanshi;
            systemdTarget = config.nixconf.system.desktop.wm.kanshiTarget;

            settings = [
              {
                profile = {
                  name = "docked";
                  outputs = [
                    {
                      criteria = "eDP-1";
                      status = "enable";
                      scale = 2.0;
                      position = "0,360";
                      mode = "3456x2160@60Hz";
                    }
                    {
                      criteria = "DP-4";
                      status = "enable";
                      scale = 1.0;
                      position = "1728,0";
                      mode = "2560x1440@60Hz";
                    }
                  ];
                };
              }

              {
                profile = {
                  name = "undocked";
                  outputs = [
                    {
                      criteria = "eDP-1";
                      status = "enable";
                      scale = 1.5;
                    }
                  ];
                };
              }
            ];
          };
        };
      };
    };
}
