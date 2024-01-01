{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop.greetd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable greetd login manager";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "Hyprland"; # sway --unsupported-gpu
      description = "Command to use with greetd login manager";
    };
  };

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.greetd.enable) {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd '${config.nixconf.desktop.greetd.command}'
        '';
      };
    };

    # fix bootlogs and error dumps on greetd
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";

      # Without this errors will spam on screen
      StandardError = "journal";

      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
