{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [ 
    git
    wget
    neovim
    firefox

    docker-compose
    podman-compose

    jetbrains.pycharm-professional
    teams
  ];
}
