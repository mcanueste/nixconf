{ pkgs, ... }:
{
  # Packages that don't need GUI and specific config
  home.packages = with pkgs; [                               
    htop
    ripgrep
    fd
    dive
    lazygit # TODO: configure later?
    nix-prefetch
    zk
    poetry
    gccStdenv
  ];
}

