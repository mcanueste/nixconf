{ pkgs, ... }:

let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports = [ 
    # Import home manager
    (import "${home-manager}/nixos")

    # Import partial configs
    ./starship.nix
    ./bash.nix
    ./exa.nix
    ./git.nix
    ./alacritty.nix
  ];
}
