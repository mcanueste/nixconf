{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./git
    ./neovim
    ./user.nix
    ./cli-utils.nix
    ./bash.nix
    ./fish.nix
    ./alacritty.nix
    ./starship.nix
    ./tmux.nix
    ./zellij.nix
    ./browsers.nix
    ./chat.nix
    ./cloud.nix
    ./editors.nix

    ./desktop
  ];
}
