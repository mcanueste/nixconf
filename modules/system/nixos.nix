{
  pkgs,
  inputs,
  config,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes settings
  nix.package = pkgs.nixVersions.git;
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

  # Binary caches
  nix.settings = {
    trusted-users = ["root" "${config.nixconf.user}"];
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
