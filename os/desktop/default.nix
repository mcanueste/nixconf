{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./awesome.nix
  ];
}
