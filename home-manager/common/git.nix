{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.git = {
    enable = pkgs.libExt.mkEnabledOption "git";

    gitUsername = lib.mkOption {
      type = lib.types.str;
      default = "mcanueste";
      description = "Git username";
    };

    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "mcanueste@gmail.com";
      description = "Git email";
    };
  };

  config = let
    shellAliases = {
      g = "git";

      lg = "lazygit";

      explain = "gh copilot explain";
      suggest = "gh copilot suggest";
    };
  in
    lib.mkIf config.nixconf.git.enable {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      programs.git = {
        enable = true;
        lfs.enable = true;
        delta.enable = true;
        userName = config.nixconf.git.gitUsername;
        userEmail = config.nixconf.git.gitEmail;
        extraConfig = {
          core = {
            whitespace = "trailing-space,space-before-tab";
            editor = "nvim";
          };
          spr.requireTestPlan = false;
        };
        ignores = [".direnv"]; # things that will be ignored always
        aliases = {
          s = "status";
          a = "add";
          aa = "add --all";
          p = "pull";
          ps = "push";
          c = "commit";
          cm = "commit -m";
          cl = "clone";
          b = "branch";
          co = "checkout";
          cob = "checkout -b";
          r = "rebase";
          re = "restore";
          res = "restore --staged";
          d = "diff";
          clb = "clone --bare";
          wl = "worktree list";
          wa = "worktree add";
          wr = "worktree remove";
          wrf = "worktree remove --force";
        };
      };

      programs.gh = {
        enable = true;
        extensions = [pkgs.gh-copilot];
      };

      programs.gh-dash.enable = true;

      programs.lazygit.enable = true;

      home.packages = [
        # for stacked prs
        pkgs.spr
      ];
    };
}
