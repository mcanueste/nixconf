{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./i3.nix
  ];
}
