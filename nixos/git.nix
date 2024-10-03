{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.git = {
    enable = pkgs.libExt.mkEnabledOption "git";

    lazygit = pkgs.libExt.mkEnabledOption "lazygit";

    gh = pkgs.libExt.mkEnabledOption "GitHub Client";
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
      home-manager.users.${config.nixconf.username} = {
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
          ignores = [".direnv"]; # things that will be ignored always
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
          };
        };

        programs.gh = {
          enable = config.nixconf.git.gh;
          extensions = [pkgs.gh-dash pkgs.gh-copilot];
        };

        programs.lazygit = {
          enable = config.nixconf.git.lazygit;
        };
      };
    };
}
