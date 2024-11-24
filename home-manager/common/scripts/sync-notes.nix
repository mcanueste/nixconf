{
  pkgs,
  lib,
  config,
  ...
}: {
  config = let
    sync-notes = pkgs.writeShellApplication {
      name = "sync-notes";
      runtimeInputs = [pkgs.git];
      text = ''
        #!/usr/bin/env bash
        echo "Backing up notes..."

        cd ~/notes/
        git add .
        if [[ "$(git status --porcelain | wc -l)" -eq "0" ]]; then
          echo "  🟢 Git repo is clean."
        else
          echo "  🔴 Git repo has updates. Pushing..."
          git commit -m "notebackup: $(date '+%Y-%m-%d %H:%M:%S')"
          git push
        fi

        echo "Done!"
        # exit 0
      '';
    };
  in
    lib.mkIf (config.nixconf.scripts.enable && config.nixconf.scripts.notes) {
      home.packages = [
        sync-notes
      ];

      systemd.user = lib.mkIf config.nixconf.scripts.systemd {
        services = {
          sync-notes = {
            Install.WantedBy = ["default.target"];
            Unit.Description = "Backup notes.";
            Service.ExecStart = "/etc/profiles/per-user/${config.nixconf.username}/bin/sync-notes";
          };
        };
        timers = {
          sync-notes = {
            Install.WantedBy = ["timers.target"];
            Unit.Description = "Backup notes hourly (if there is a change).";
            Timer = {
              OnCalendar = "*-*-* *:00:00";
              Persistent = true;
            };
          };
        };
      };
    };
}
