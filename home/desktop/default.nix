{pkgs, ...}: {
  imports = [
    ./alacritty.nix
    ./starship.nix
    ./packages.nix
  ];
}
