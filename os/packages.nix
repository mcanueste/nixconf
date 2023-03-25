{
  pkgs,
  lib,
  config,
  ...
}: {
  # System level packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
  ];
}
