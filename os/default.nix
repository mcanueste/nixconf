{
  pkgs,
  lib,
  config,
  ...
}: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];
    # substituters = [
    #   "https://nix-community.cachix.org"
    # ];
    # trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
    # trusted-users = ["@wheel"];
    warn-dirty = false;
  };

  imports = [
    ./hardware
    ./desktop
    ./user.nix
    ./packages.nix
    ./sound.nix
    ./locale.nix
    ./networking.nix
    ./virtualization.nix
  ];
}
