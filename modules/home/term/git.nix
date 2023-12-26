{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    git = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git config";
    };
  };

  config = lib.mkIf config.nixconf.term.git {
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
        clb = "clone --bare";

        b = "branch";

        co = "checkout";
        cob = "checkout -b";

        r = "rebase";
        r2 = "rebase -i HEAD~2";

        re = "restore";
        res = "restore --staged";

        d = "diff";

        wa = "worktree add";
        wr = "worktree remove";
        wrf = "worktree remove --force";
      };
    };
  };
}
