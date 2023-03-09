{
  pkgs,
  lib,
  config,
  ...
}: {
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.username = "mcst";
  home.homeDirectory = "/home/mcst";

  imports = [
    ./cli-utils.nix
    ./bash.nix
    ./alacritty.nix
    ./starship.nix
    ./tmux.nix
    ./browsers.nix
    ./chat.nix
    ./cloud.nix
    ./editors.nix
    ./git
    ./neovim
  ];
}
