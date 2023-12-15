{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term.systemd;
  scriptsCfg = config.nixhome.term.scripts;
  setupServices = builtins.foldl' (a: b: lib.recursiveUpdate a b) {};

  eye-strain-notify-service = {
    services.eye-strain-notify = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Send notification to take 20sec break for preventing eye strain.";
      Service.ExecStart = "${pkgs.libnotify}/bin/notify-send 'Break' 'Eye strain break 20 secs!' -u critical";
    };
    timers.eye-strain-notify = {
      Install.WantedBy = ["timers.target"];
      Unit.Description = "Trigger eye strain notification on 20 and 40 min mark of every hour.";
      Timer.OnCalendar = "*-*-* *:20,40:00";
    };
  };

  stretch-notify-service = {
    services.stretch-notify = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Send notification to take break a break and stretch for preventing Gollumification.";
      Service.ExecStart = "${pkgs.libnotify}/bin/notify-send 'Break' 'Stretch!' -u critical";
    };
    timers.stretch-notify = {
      Install.WantedBy = ["timers.target"];
      Unit.Description = "Trigger strecth notification every hour.";
      Timer.OnCalendar = "*-*-* *:00:00";
    };
  };

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
      Service.ExecStart = "/etc/profiles/per-user/${config.nixhome.user.username}/bin/sync-notes";
    };
    timers.sync-notes = hourly-timer;
  };

  sync-german-service = {
    services.sync-german = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Backup German notes.";
      Service.ExecStart = "/etc/profiles/per-user/${config.nixhome.user.username}/bin/sync-german";
    };
    timers.sync-german = hourly-timer;
  };

  sync-blog-service = {
    services.sync-blog = {
      Install.WantedBy = ["default.target"];
      Unit.Description = "Sync blog notes and push changes.";
      Service.ExecStart = "/etc/profiles/per-user/${config.nixhome.user.username}/bin/sync-blog";
    };
    timers.sync-blog = hourly-timer;
  };
in {
  options.nixhome.term.systemd = {
    enabled = mkBoolOption {description = "Enable user space systemd services";};

    eye-strain-notify = mkBoolOption {description = "Enable eye strain notification timer";};
    stretch-notify = mkBoolOption {description = "Enable stretch notification timer";};

    sync-notes = mkBoolOption {description = "Enable sync-notes script for pushing notes to gitlab";};
    sync-german = mkBoolOption {description = "Enable sync-german script for pushing German notes to gitlab";};
    sync-blog = mkBoolOption {description = "Enable sync-blog script for moving blog notes from Obsidian vault and pushing changes to github";};
  };

  config = lib.mkIf cfg.enabled {
    systemd.user = setupServices (builtins.filter (p: p != null) [
      (
        if cfg.eye-strain-notify
        then eye-strain-notify-service
        else null
      )
      (
        if cfg.stretch-notify
        then stretch-notify-service
        else null
      )
      (
        if cfg.sync-notes && scriptsCfg.sync-notes
        then sync-notes-service
        else null
      )
      (
        if cfg.sync-german && scriptsCfg.sync-german
        then sync-german-service
        else null
      )
      (
        if cfg.sync-blog && scriptsCfg.sync-blog
        then sync-blog-service
        else null
      )
    ]);
  };
}
