{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    pretty = "prettybat";
    brg = "batgrep";
  };

  theme = pkgs.catppuccin.override {
    accent = "sky";
    variant = "mocha";
    themeList = ["bat"];
  };
in {
  options.nixconf.term = {
    bat = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable bat";
    };
  };

  config = lib.mkIf config.nixconf.term.bat {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          prettybat
          batgrep

          # requires config - TODO: check if needed
          # batwatch
          # batpipe
          # batman
          # batdiff
        ];
        config.theme = "catppuccin";
        themes = {
          catppuccin = {
            src = "${theme}/bat/";
            file = "Catppuccin-mocha.tmTheme";
          };
        };
      };
    };
  };
}
