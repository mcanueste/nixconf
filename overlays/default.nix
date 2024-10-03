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
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # Custom utility functions to pass onto the configurations
  lib = final: prev: {
    libExt = prev.lib // (import ../lib {lib = prev.lib;});
  };
}
