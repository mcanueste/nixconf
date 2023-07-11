{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;

  shellAliases = {
    db = "distrobox";
  };

  distrobox = pkgs.distrobox.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "mcanueste";
      repo = "distrobox";
      rev = "fix-pure-flake-nixos-mounts";
      sha256 = "sha256-aFmjZvqPcEfx2P+jJ7U7V/7MwWQr8TxY8VqLf6PM108=";
    };
  });
in {
  options.nixhome.tools = {
    distrobox = mkBoolOption {description = "Enable distrobox";};
  };

  config = lib.mkIf cfg.distrobox {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    home.packages = [
      distrobox
    ];
  };
}
