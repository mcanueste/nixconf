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
      neovim
      gcc
      stdenv
      xclip
      xsel
      wl-clipboard
      git
      ripgrep
      fd
      wget
      curl
      gzip
      gnutar
      lazygit
      go
      cargo
      rustc
      nodejs
      nodePackages.npm
      nodePackages.neovim
      (luajit.withPackages (lp: [
        lp.luarocks
      ]))
      (python311.withPackages (pp: [
        pp.pip
        pp.pynvim
      ]))
    ];

    xdg.configFile."nvim/" = {
      source = ./nvim;
      recursive = true;
    };
  };
}
