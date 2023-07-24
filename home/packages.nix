{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    home.packages = [
      pkgs.dash

      pkgs.rsync
      pkgs.gnumake
      pkgs.dig
      pkgs.traceroute
      pkgs.tree

      pkgs.entr
      pkgs.ripgrep
      pkgs.fd

      pkgs.tealdeer
      pkgs.manix

      pkgs.htop
      pkgs.ncdu
      pkgs.dive
      pkgs.just
    ];
  };
}
