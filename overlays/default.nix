packages: let
  libOverlay = import ./lib.nix;
  pkgsOverlay = import ./pkgs.nix packages;
in [
  libOverlay
  pkgsOverlay
]
