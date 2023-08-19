{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;

  blogsync = pkgs.writeShellApplication {
    name = "blogsync";
    runtimeInputs = [pkgs.rsync pkgs.hugo];
    text = ''
      export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:/home/mcst/.config"
      export PATH="$PATH:/run/current-system/sw/bin"
      echo "Syncing blog notes from Obsidian vault to blog repository..."
      rsync ~/notes/blog/*.md ~/Projects/blog/content/blog/
      cd ~/Projects/blog/
      hugo
      git add .
      if [[ "$(git status --porcelain | wc -l)" -eq "0" ]]; then
        echo "  🟢 Git repo is clean."
      else
        echo "  🔴 Git repo has updates. Pushing..."
        git commit -m "blogsync: $(date '+%Y-%m-%d %H:%M:%S')"
        git push
      fi
      echo "Done!"
      exit 0
    '';
  };

  notebackup = pkgs.writeShellApplication {
    name = "notebackup";
    runtimeInputs = [pkgs.git];
    text = ''
      export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:/home/mcst/.config"
      export PATH="$PATH:/run/current-system/sw/bin"
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
      exit 0
    '';
  };

  germanbackup = pkgs.writeShellApplication {
    name = "germanbackup";
    runtimeInputs = [pkgs.git];
    text = ''
      export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:/home/mcst/.config"
      export PATH="$PATH:/run/current-system/sw/bin"
      echo "Backing up notes..."
      cd ~/german/
      git add .
      if [[ "$(git status --porcelain | wc -l)" -eq "0" ]]; then
        echo "  🟢 Git repo is clean."
      else
        echo "  🔴 Git repo has updates. Pushing..."
        git commit -m "germanbackup: $(date '+%Y-%m-%d %H:%M:%S')"
        git push
      fi
      echo "Done!"
      exit 0
    '';
  };
in {
  options.nixhome.tools = {
    obsidian = mkBoolOption {description = "Enable obsidian";};
    hugo = mkBoolOption {description = "Enable hugo";};
  };

  config = lib.mkIf cfg.git {
    home.packages = filterPackages [
      (getPackageIf cfg.obsidian pkgs.obsidian)
      (getPackageIf cfg.obsidian notebackup)
      (getPackageIf cfg.obsidian germanbackup)
      (getPackageIf cfg.hugo pkgs.hugo)
      (getPackageIf cfg.hugo blogsync)
    ];

    systemd.user = {
      services = {
        german-backup = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Backup German notes.";
          Service.ExecStart = "${germanbackup}/bin/germanbackup";
        };
        notes-backup = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Backup notes.";
          Service.ExecStart = "${notebackup}/bin/notebackup";
        };
        blog-sync = {
          Install.WantedBy = ["default.target"];
          Unit.Description = "Sync blog.";
          Service.ExecStart = "${blogsync}/bin/blogsync";
        };
      };
      timers = {
        german-backup = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Backup German notes hourly (if there is a change).";
          Timer = {
            OnCalendar = "*-*-* *:00:00";
            Persistent = true;
          };
        };
        notes-backup = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Backup notes hourly (if there is a change).";
          Timer = {
            OnCalendar = "*-*-* *:00:00";
            Persistent = true;
          };
        };
        blog-sync = {
          Install.WantedBy = ["timers.target"];
          Unit.Description = "Sync blog hourly (if there is a change).";
          Timer = {
            OnCalendar = "*-*-* *:00:00";
            Persistent = true;
          };
        };
      };
    };
  };
}
