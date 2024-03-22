{
  pkgs,
  inputs,
  config,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes settings
  nix.package = pkgs.nixVersions.unstable;
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
      # "https://cache.garnix.io" no need for this
      # "https://hyprland.cachix.org" really slow...
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [
  #   # Add any missing dynamic libraries for unpackaged programs
  #   # here, NOT in environment.systemPackages
  #   pkgs.jemalloc
  #   pkgs.rust-jemalloc-sys
  # ];

  imports = [
    ./browsers.nix
    ./chat.nix
    ./desktop
    ./editors
    ./font.nix
    ./gaming.nix
    ./hardware
    ./locale.nix
    ./media.nix
    ./networking.nix
    ./packages.nix
    ./security.nix
    ./term
    ./tools
    ./user.nix
    ./virtualization.nix
  ];
}
