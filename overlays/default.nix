{inputs, ...}: {
  # Make stable packages available via 'pkgs.stable'
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # Bring custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs final.pkgs;

  # Change versions, add patches, set compilation flags, etc.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Had to add a patch to fix a bug in Nix CLI for "too many open files" error
    # nix.package = pkgs.nixVersions.latest.overrideAttrs (drv: {
    #   patches =
    #     (drv.patches or [])
    #     ++ [
    #       (pkgs.fetchpatch {
    #         url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/11402.patch";
    #         hash = "sha256-RgA65xGCWU6F/7U8/5vIoghRptELKu8i6U3SZY/1GVw=";
    #       })
    #     ];
    # });
  };

  # Custom utility functions to pass onto the configurations
  lib = final: prev: {
    libExt = prev.lib // (import ../lib {lib = prev.lib;});
  };
}
