{ pkgs, ... }:

let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports = [ 
    # Import home manager
    (import "${home-manager}/nixos")

    # Import program configs
    ./programs/alacritty.nix
    ./programs/starship.nix
    ./programs/bash.nix
    ./programs/dircolors.nix
    ./programs/exa.nix
    ./programs/fzf.nix
    ./programs/tealdeer.nix
    ./programs/git.nix
    # ./programs/direnv.nix
  ];

  # Enable lorri service
  # services.lorri.enable = true;

  home-manager.users.mcst = {
    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" "Hack" ]; })
    ];
  }; 
}
