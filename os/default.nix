{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./user.nix
    ./hardware
    ./desktop
    ./packages.nix
    ./common.nix
    ./networking.nix
    ./virtualization.nix
    ./gaming.nix
  ];
}
