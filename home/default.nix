{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  imports = [
    ./user.nix
    ./browsers.nix
    ./media.nix
    ./chat.nix
    ./term
    ./editors
    ./devops
    ./desktop
    ./tools
    ./font.nix
    ./packages.nix
    ./systemd.nix
  ];
}
