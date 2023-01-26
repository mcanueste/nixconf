{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "mcanueste";
    userEmail = "mcanueste@gmail.com";

    # TODO: add signing
    # signing = ?

    # TODO: add additional configs for certain dirs
    # includes = [
    #   {
    #     path = "~/path/to/conditional.inc";
    #     condition = "gitdir:~/src/dir";
    #   }
    # ]

    extraConfig = {
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "nvim";
      };
    };

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
      d = "diff";
    };
  };
}
