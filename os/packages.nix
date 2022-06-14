{ pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Enable zsa keyboard udev rules
  # hardware.keyboard.zsa.enable = true;

  environment.systemPackages = with pkgs; [ 
    git
    wget
    neovim
    firefox

    docker-compose
    podman-compose

    jetbrains.pycharm-professional
    teams

#    wally-cli
  ];
}
