{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.neovim;
in {
  options.nixhome.neovim = {
    enable = lib.mkOption {
      description = "Enable neovim configuration";
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    home.packages = with pkgs; [
      stdenv
      neovim

      # nix support
      # alejandra
      # nil
    ];

    xdg.configFile."nvim/" = {
      source = ./nvim;
      recursive = true;
    };
  };
}
