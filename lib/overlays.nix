let
  pkgsOverlay = packages: final: prev: {
    nixvimPackages =
      builtins.mapAttrs
      (n: v: v.defaultPackage.${final.system})
      packages;
  };

  libOverlay = lib: final: prev: {
    lib = prev.lib // {nixconf = lib;};
  };
in {
  inherit pkgsOverlay libOverlay;
}
