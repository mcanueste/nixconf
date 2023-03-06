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
    ./desktop
    ./packages.nix
    ./bash.nix
    ./alacritty.nix
    ./git.nix
    ./neovim
  ];
}
