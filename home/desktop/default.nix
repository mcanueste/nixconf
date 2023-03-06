{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./desktop.nix
    ./starship.nix
  ];
}
