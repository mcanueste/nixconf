{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./qtile.nix
  ];
}
