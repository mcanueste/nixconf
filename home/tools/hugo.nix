{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;
  blogsync = pkgs.writeShellScriptBin "blogsync" ''
    echo "Syncing blog notes from Obsidian vault to blog repository..."
    rsync ./notes/blog/*.md ~/Projects/blog/content/blog/
    cd ~/Projects/blog/
    hugo
    git add .
    if [ $(git status --porcelain | wc -l) -eq "0" ]; then
      echo "  🟢 Git repo is clean."
    else
      echo "  🔴 Git repo has updates. Pushing..."
      git commit -m "blogsync: $(date '+%Y-%m-%d %H:%M:%S')"
      git push
    fi
    echo "Done!"
    exit 0
  '';
  notebackup = pkgs.writeShellScriptBin "notebackup" ''
    echo "Backing up notes..."
    cd ~/notes/
    git add .
    if [ $(git status --porcelain | wc -l) -eq "0" ]; then
      echo "  🟢 Git repo is clean."
    else
      echo "  🔴 Git repo has updates. Pushing..."
      git commit -m "notebackup: $(date '+%Y-%m-%d %H:%M:%S')"
      git push
    fi
    echo "Done!"
    exit 0
  '';
in {
  options.nixhome.tools = {
    hugo = mkBoolOption {description = "Enable hugo";};
  };

  config = lib.mkIf cfg.git {
    home.packages = [
      pkgs.hugo
      pkgs.rsync
      blogsync
      notebackup
    ];
  };
}
