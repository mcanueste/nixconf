{ ... }:
{
  home-manager.users.mcst = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "mcanueste";
      userEmail = "mcanueste@gmail.com";
    };
  };
}
