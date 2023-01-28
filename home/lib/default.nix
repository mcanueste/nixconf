let
  pkgsOverlay = packages: final: prev:
    prev
    // builtins.mapAttrs
    (n: v: v.defaultPackage.${final.system})
    packages;

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
  inherit pkgsOverlay mkPkgs;
}
