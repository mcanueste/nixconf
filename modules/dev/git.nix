{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable git config";
    };

    lazygit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Lazygit";
    };

    gh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "GitHub Client";
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
    lib.mkIf config.nixconf.dev.git.enable {
      home-manager.users.${config.nixconf.os.user} = {
        programs.bash = {inherit shellAliases;};
        programs.zsh = {inherit shellAliases;};
        programs.fish = {inherit shellAliases;};

        programs.git = {
          enable = true;
          lfs.enable = true;
          delta.enable = true;
          userName = "mcanueste";
          userEmail = "mcanueste@gmail.com";
          extraConfig = {
            core = {
              whitespace = "trailing-space,space-before-tab";
              editor = "nvim";
            };
          };
          ignores = [".direnv"];  # things that will be ignored always
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

            re = "restore";
            res = "restore --staged";

            d = "diff";

            clb = "clone --bare";
            wl = "worktree list";
            wa = "worktree add";
            wr = "worktree remove";
            wrf = "worktree remove --force";

            # fix-remote-branches = "config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'";
          };
        };

        programs.gh = {
          enable = config.nixconf.dev.git.gh;
          extensions = [pkgs.gh-dash pkgs.gh-copilot];
        };

        programs.lazygit = {
          enable = config.nixconf.dev.git.lazygit;
        };
      };
    };
}
