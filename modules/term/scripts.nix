{
  pkgs,
  lib,
  config,
  ...
}: let
  sync-notes = pkgs.writeShellApplication {
    name = "sync-notes";
    runtimeInputs = [pkgs.git];
    text = ''
      #!/usr/bin/env bash
      echo "Backing up notes..."

      cd ~/Projects/personal/notes/
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

  sync-blog = pkgs.writeShellApplication {
    name = "sync-blog";
    runtimeInputs = [pkgs.rsync pkgs.hugo];
    text = ''
      #!/usr/bin/env bash
      echo "Syncing blog notes from Obsidian vault to blog repository..."

      rsync -r ~/Projects/personal/notes/blog/* ~/Projects/personal/blog/content/posts/
      cd ~/Projects/personal/blog/
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
in {
  options.nixconf.term = {
    scripts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable scripts";
    };
  };

  config = lib.mkIf config.nixconf.term.scripts {
    home-manager.users.${config.nixconf.os.user} = {
      home.packages = [
        sync-notes
        sync-blog
      ];
    };
  };
}
