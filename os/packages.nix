{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    vim
    unzip
  ];
}
