{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./neovim
  ];

  options.nixconf.editor.neovim = pkgs.libExt.mkEnabledOption "neovim";

  config = lib.mkIf config.nixconf.editor.neovim {
    programs = let
      shellAliases = {
        v = "nvim";
      };
    in {
      bash = {inherit shellAliases;};
      fish = {inherit shellAliases;};
      nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        globals = {
          mapleader = " ";
          maplocalleader = "\\";
          markdown_recommended_style = 0; # Fix markdown indentation settings
        };
      };
    };
  };
}
