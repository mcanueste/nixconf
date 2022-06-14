{ pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [ 
    git
    wget
    neovim
    firefox

    jetbrains.pycharm-professional
    teams
  ];
}
