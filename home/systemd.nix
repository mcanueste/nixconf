{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    systemd.user = {
      services = {
        notes-backup = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Backup notes everyday.";
          Service.ExecStart = ''
            ${pkgs.bash}/bin/bash -c "cd ~/notes/ && git add . && git commit -m 'Backup: $(date +%Y-%m-%d)' && git push"
          '';
        };
        eye-strain-notify = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Send notification to take 20sec break for preventing eye strain.";
          Service.ExecStart = "${pkgs.libnotify}/bin/notify-send 'Break' 'Eye strain break 20 secs!' -u critical";
        };
        stretch-notify = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Send notification to take break a break and stretch for preventing Gollumification.";
          Service.ExecStart = "${pkgs.libnotify}/bin/notify-send 'Break' 'Stretch!' -u critical";
        };
      };
      timers = {
        notes-backup = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Backup notes daily.";
          Timer = {
            OnCalendar = "*-*-* 03:00:00";
            Persistent = true;
          };
        };
        eye-strain-notify = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Trigger eye strain notification on 20 and 40 min mark of every hour.";
          Timer.OnCalendar = "*-*-* *:20,40:00";
        };
        stretch-notify = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Trigger strecth notification every hour.";
          Timer.OnCalendar = "*-*-* *:00:00";
        };
      };
    };
  };
}
