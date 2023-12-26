{
  # not considered since we use unstable via flake,
  # but need to give it here so the error msg is gone.
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  imports = [
    ./user.nix
    ./browsers.nix
    ./media.nix
    ./chat.nix
    ./font.nix
    ./desktop
    ./term
    ./tools
    ./editors
  ];
}
