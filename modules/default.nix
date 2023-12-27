{
  pkgs,
  inputs,
  ...
}: {
  # not considered since we use unstable via flake,
  # but need to give it here so the error msg is gone.
  system.stateVersion = "24.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # optimise nix store daily
    optimise.automatic = true;

    # Flakes settings
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      # optimise nix store after each build
      auto-optimise-store = true;

      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  imports = [
    ./user.nix
    ./locale.nix
    ./sound.nix
    ./networking.nix
    ./security.nix
    ./printer.nix
    ./logitech.nix
    ./virtualization.nix
    ./hardware
    ./desktop
    ./gaming.nix
    ./browsers.nix
    ./chat.nix
    ./font.nix
    ./media.nix
    ./editors
    ./tools
    ./term
    ./packages.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
