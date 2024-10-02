{
  pkgs,
  inputs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes settings
  nix.package = pkgs.nixVersions.latest;

  # nix CLI was broken with "too many open files" error...
  # had to get the patch, apply it and rebuild nix to get latest nix CLI
  # which has the fixes for the error
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

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.warn-dirty = false;

  # Optimise store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Automate garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Avoid unwanted garbage collection when using nix-direnv
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;
}
