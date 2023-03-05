let
  pkgsOverlay = import ../overlays/pkgs.nix;
  mkPkgs = {
    nixpkgs,
    packages ? {},
    config ? {},
    system ? "x86_64-linux",
  }:
    import nixpkgs {
      inherit system config;
      overlays = [
        (pkgsOverlay packages)
      ];
    };
in {
  inherit mkPkgs;
}
