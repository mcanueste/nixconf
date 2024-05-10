{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev = {
    git = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable git config";
    };
  };

  config = lib.mkIf config.nixconf.dev.git {
    home-manager.users.${config.nixconf.system.user} = {
      programs.bash = {
        shellAliases = {
          g = "git";
        };
      };

      programs.fish = {
        shellAliases = {
          g = "git";
        };
      };

      programs.git = {
        enable = true;
        lfs.enable = true;
        delta.enable = true;
        userName = "mcanueste"; # TODO: get these vals from config
        userEmail = "mcanueste@gmail.com";
        extraConfig = {
          core = {
            whitespace = "trailing-space,space-before-tab";
            editor = "nvim";
          };
        };
        aliases = {
          s = "status";

          a = "add";
          aa = "add --all";

          p = "push";
          pl = "pull";

          c = "commit";
          cm = "commit -m";

          cl = "clone";

          b = "branch";

          co = "checkout";
          cob = "checkout -b";

          r = "rebase";
          r2 = "rebase -i HEAD~2";

          re = "restore";
          res = "restore --staged";

          d = "diff";

          clb = "clone --bare";
          wl = "worktree list";
          wa = "worktree add";
          wr = "worktree remove";
          wrf = "worktree remove --force";

          # might move this to the main config
          fix-remote-branches = "config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'";
        };
      };
    };
  };
}
