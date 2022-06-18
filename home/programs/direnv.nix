{ ... }:
{
  home-manager.users.mcst = {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
  };
}
