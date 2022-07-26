{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
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
    ./programs/helix.nix
  ];

  # Enable lorri service
  # services.lorri.enable = true;

  # User based nixpkgs config
  home-manager.users.mcst = {
    home.stateVersion = "22.05";

    xdg = {
      enable = true;
      configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
    };

    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" "Hack" ]; })
    ];
  };
}
