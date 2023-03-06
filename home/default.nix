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
    ./bash.nix
    ./alacritty.nix
    ./starship.nix
    ./git.nix
    ./packages.nix
    ./neovim
  ];
}
