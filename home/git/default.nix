{
  pkgs,
  lib,
  config,
  ...
}: with pkgs.lib.conflib; let
  cfg = config.nixhome.git;
in {
  options.nixhome.git = {
    enable = mkBoolOption { description = "Enable git config"; };
    lfs = mkBoolOption { description = "Enable git-lfs"; };
  };

  config = lib.mkIf cfg.enable {
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
      lfs.enable = cfg.lfs;

      delta.enable = true;
      userName = "mcanueste";
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

        b = "branch";
        co = "checkout";
        cob = "checkout -b";

        r = "rebase";
        r2 = "rebase -i HEAD~2";

        re = "restore";

        d = "diff";
      };
    };
  };
}
