{ ... }:
{
  home-manager.users.mcst = {
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };
  };
}
