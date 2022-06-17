{ ... }:
{
  home-manager.users.mcst = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };
  };
}
