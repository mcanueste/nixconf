{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
  ];

  # security.polkit.enable = true;
  # programs.light.enable = true;
}
