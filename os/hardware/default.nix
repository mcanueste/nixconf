{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./xps-15-9570.nix
  ];

  # Enable CUPS to print document
  services.printing.enable = true;
}
