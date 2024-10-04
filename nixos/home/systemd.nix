{
  pkgs,
  config,
  lib,
  ...
}: let
  setupServices = builtins.foldl' (a: b: lib.recursiveUpdate a b) {};

  hourly-timer = {
    Install.WantedBy = ["timers.target"];
    Unit.Description = "Backup notes hourly (if there is a change).";
    Timer = {
      OnCalendar = "*-*-* *:00:00";
      Persistent = true;
    };
  };

  sync-notes-service = {
    services.sync-notes = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Backup notes.";
      Service.ExecStart = "/etc/profiles/per-user/${config.nixconf.username}/bin/sync-notes";
    };
    timers.sync-notes = hourly-timer;
  };

  sync-blog-service = {
    services.sync-blog = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Sync blog notes and push changes.";
      Service.ExecStart = "/etc/profiles/per-user/${config.nixconf.username}/bin/sync-blog";
    };
    timers.sync-blog = hourly-timer;
  };
in {
  options.nixconf.systemd = {
    enable = lib.mkEnableOption "user space systemd services";

    sync-notes = lib.mkEnableOption "sync-notes script for pushing notes to git";

    sync-blog = lib.mkEnableOption "sync-blog script for moving blog notes from Obsidian vault and pushing changes to github";
  };

  config = lib.mkIf config.nixconf.systemd.enable {
    home-manager.users.${config.nixconf.username} = {
      systemd.user = setupServices (pkgs.libExt.filterNull [
        (pkgs.libExt.mkIfElseNull config.nixconf.systemd.sync-notes sync-notes-service)
        (pkgs.libExt.mkIfElseNull config.nixconf.systemd.sync-blog sync-blog-service)
      ]);
    };
  };
}
