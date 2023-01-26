let
  overlays = import ./overlays.nix;

  mkPkgs = {
    nixpkgs,
    plugins ? {},
    packages ? {},
    config ? {},
    system ? "x86_64-linux",
  }:
    import nixpkgs {
      inherit system config;
      overlays = [
        # (overlays.libOverlay nixvim)
        (overlays.pkgsOverlay packages)
      ];
    };

  loadModules = {
    pkgs,
    config ? {},
    modulesPath ? ../modules,
  }:
    pkgs.lib.evalModules {
      specialArgs = {inherit pkgs;};
      modules = [
        {imports = [modulesPath];}
        config
      ];
    };
in {
  inherit overlays mkPkgs loadModules;
}
