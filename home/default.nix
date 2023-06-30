{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  imports = [
    ./user.nix
    ./browsers.nix
    ./media.nix
    ./chat.nix
    ./term
    ./git
    ./editors
    ./dev
    ./devops
    ./desktop
  ];
}
