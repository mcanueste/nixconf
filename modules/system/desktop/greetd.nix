{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop.greetd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable greetd login manager";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "Hyprland";
      description = "Command to use with greetd login manager";
    };
  };

  config = lib.mkIf (config.nixconf.system.desktop.enable && config.nixconf.system.desktop.greetd.enable) {
    # TODO: this is buggy on different resolution displays
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd '${config.nixconf.system.desktop.greetd.command}'
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
