{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    systemd.user = {
      services = {
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
