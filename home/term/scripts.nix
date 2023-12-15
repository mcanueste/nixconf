{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term.scripts;

  nvidia-offload = pkgs.writeShellApplication {
    name = "nvidia-offload";
    runtimeInputs = [];
    text = ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '';
  };

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

  sync-german = pkgs.writeShellApplication {
    name = "sync-german";
    runtimeInputs = [pkgs.git];
    text = ''
      #!/usr/bin/env bash
      echo "Backing up German notes..."

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
      # exit 0
    '';
  };

  sync-blog = pkgs.writeShellApplication {
    name = "sync-blog";
    runtimeInputs = [pkgs.rsync pkgs.hugo];
    text = ''
      #!/usr/bin/env bash
      echo "Syncing blog notes from Obsidian vault to blog repository..."

      rsync ~/notes/blog/*.md ~/Projects/blog/content/blog/
      cd ~/Projects/blog/
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
      # exit 0
    '';
  };
in {
  options.nixhome.term.scripts = {
    enabled = mkBoolOption {description = "Enable scripts";};
    nvidia-offload = mkBoolOption {description = "Enable nvidia-offload script";};
    sync-notes = mkBoolOption {description = "Enable sync-notes script for pushing notes to gitlab";};
    sync-german = mkBoolOption {description = "Enable sync-german script for pushing German notes to gitlab";};
    sync-blog = mkBoolOption {description = "Enable sync-blog script for moving blog notes from Obsidian vault and pushing changes to github";};
  };

  config = lib.mkIf cfg.enabled {
    home.packages = filterPackages [
      (getPackageIf cfg.nvidia-offload nvidia-offload)
      (getPackageIf cfg.sync-notes sync-notes)
      (getPackageIf cfg.sync-german sync-german)
      (getPackageIf cfg.sync-blog sync-blog)
    ];
  };
}
