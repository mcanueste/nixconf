{ ... }:
{
  home-manager.users.mcst = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };
  };
}
