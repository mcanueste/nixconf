{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.cli-utils;
in {
  options.nixhome.cli-utils = {
    enable = mkBoolOption {description = "Enable cli utils";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.openssl
      pkgs.dash
      pkgs.rsync
      pkgs.gnumake
      pkgs.ripgrep
      pkgs.fd
      pkgs.htop
      pkgs.dive
      pkgs.tealdeer
      pkgs.ncdu
      pkgs.dig
      pkgs.traceroute
      pkgs.tree
      pkgs.entr
      pkgs.manix
    ];
  };
}
