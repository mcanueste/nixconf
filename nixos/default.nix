{outputs, ...}: {
  nix.settings = {
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.lib

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./os
    ./term
    ./dev
    ./theme.nix
  ];
}
