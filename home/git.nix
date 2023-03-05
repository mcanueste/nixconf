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
    programs.git = {
      enable = cfg.enable;
      lfs.enable = cfg.lfs;

      userName = "mcanueste";
      userEmail = "mcanueste@gmail.com";

      # TODO: add additional configs for certain dirs
      # includes = [
      #   {
      #     path = "~/path/to/conditional.inc";
      #     condition = "gitdir:~/src/dir";
      #   }
      # ]

      # TODO: add signing
      # signing = ?

      extraConfig = {
        core = {
          whitespace = "trailing-space,space-before-tab";
          editor = "nvim";
        };
      };

      # TODO: maybe change to another diff tool?
      diff-so-fancy.enable = true;
	
      aliases = {
        a = "add";
        aa = "add --all";
        s = "status";
        p = "push";
        pl = "pull";
        b = "branch";
        c = "commit";
        cm = "commit -m";
        co = "checkout";
        r = "rebase";
        r2 = "rebase -i HEAD~2";
        re = "restore";
        d = "diff";
      };
    };
  };
}
