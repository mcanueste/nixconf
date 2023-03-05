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
    ./git.nix
  ];

  # home.sessionVariables = {
  #   EDITOR = "nvim";
  #   ZK_NOTEBOOK_DIR = "~/Projects/notes";
  # };
}
