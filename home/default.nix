{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./term
    ./git
    ./neovim
    ./user.nix
    ./browsers.nix
    ./editors.nix
    ./media.nix
    ./chat.nix
    ./desktop
    ./devops
    ./dev
  ];
}
