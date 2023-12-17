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
    ./common.nix
    ./networking.nix
    ./virtualization.nix
    ./gaming.nix
  ];
}
