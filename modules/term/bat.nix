{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    bat = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bat";
    };
  };

  config = lib.mkIf config.nixconf.term.bat {
    home-manager.users.${config.nixconf.user} = let
      shellAliases = {
        rgb = "batgrep";
        man = "batman";
        pretty = "prettybat";
      };

      theme = pkgs.catppuccin.override {
        accent = "sky";
        variant = "mocha";
        themeList = ["bat"];
      };
    in {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batgrep
          batman
          prettybat

          # requires config - TODO: check if needed
          # batwatch
          # batpipe
          # batdiff
        ];
        config.theme = "catppuccin";
        themes = {
          catppuccin = {
            src = "${theme}/bat/";
            file = "Catppuccin Mocha.tmTheme";
          };
        };
      };
    };
  };
}
