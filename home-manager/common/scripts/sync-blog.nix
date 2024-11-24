{
  pkgs,
  lib,
  config,
  ...
}: {
  config = let
    sync-blog = pkgs.writeShellApplication {
      name = "sync-blog";
      runtimeInputs = [pkgs.rsync pkgs.hugo];
      text = ''
        #!/usr/bin/env bash
        echo "Syncing blog notes from Obsidian vault to blog repository..."

        rsync -r ~/notes/blog/* ~/blog/content/posts/
        cd ~/blog/
        hugo

        git add .
        if [[ "$(git status --porcelain | wc -l)" -eq "0" ]]; then
          echo " 🟢 Git repo is clean."
        else
          echo " 🔴 Git repo has updates. Pushing..."
          git commit -m "blogsync: $(date '+%Y-%m-%d %H:%M:%S')"
          git push
        fi

        echo "Done!"
      '';
    };
  in
    lib.mkIf (config.nixconf.scripts.enable && config.nixconf.scripts.notes) {
      home.packages = [
        sync-blog
      ];

      systemd.user = lib.mkIf config.nixconf.scripts.systemd {
        services = {
          sync-blog = {
            Install.WantedBy = ["default.target"];
            Unit.Description = "Sync blog notes and push changes.";
            Service.ExecStart = "/etc/profiles/per-user/${config.nixconf.username}/bin/sync-blog";
          };
        };
        timers = {
          sync-blog = {
            Install.WantedBy = ["timers.target"];
            Unit.Description = "Backup blog notes hourly (if there is a change).";
            Timer = {
              OnCalendar = "*-*-* *:00:00";
              Persistent = true;
            };
          };
        };
      };
    };
}
