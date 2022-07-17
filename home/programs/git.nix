{ ... }:
{
  home-manager.users.mcst = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "mcanueste";
      userEmail = "mcanueste@gmail.com";
      aliases = {
        a = "add";
        s = "status";
        p = "push";
	pl = "pull";
        b = "branch";
        c = "commit";
        cm = "commit -m";
        co = "checkout";
      };
    };
  };
}
