{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./desktop.nix
    ./alacritty.nix
    ./starship.nix
  ];
}
