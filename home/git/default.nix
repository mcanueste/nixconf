{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.git;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
in {
  options.nixhome.git = {
    enable = mkBoolOption "Enable git config";
    lfs = mkBoolOption "Enable git-lfs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lazygit
    ];

    xdg.configFile."git/kreo.conf" = {
      source = ./kreo.conf;
    };

    programs.bash = {
      shellAliases = {
        g = "git";
        lg = "lazygit";
      };
    };

    programs.fish = {
      shellAliases = {
        g = "git";
        lg = "lazygit";
      };
    };

    programs.git = {
      enable = true;
      lfs.enable = cfg.lfs;

      delta.enable = true;
      userName = "mcanueste";
      userEmail = "mcanueste@gmail.com";
      includes = [
        {
          condition = "gitdir:/home/mcst/kreo/";
          path = "/home/mcst/.config/git/kreo.conf";
        }
      ];
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
