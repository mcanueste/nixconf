{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.desktop;
in {
  options.nixos.desktop = {
    i3 = mkBoolOption {description = "Enable i3 window manager";};
  };

  config = lib.mkIf cfg.i3 {
    # ------ Use greetd with sway TODO: how to start i3 from here?
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     # default_session.command = ''
    #     #   ${pkgs.greetd.tuigreet}/bin/tuigreet \
    #     #     --time \
    #     #     --asterisks \
    #     #     --user-menu \
    #     #     --cmd 'sway --unsupported-gpu'
    #     # '';
    #   };
    # };

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

    # links /libexec from derivations to /run/current-system/sw
    environment.pathsToLink = ["/libexec"];

    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
