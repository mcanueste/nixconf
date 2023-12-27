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
        themes = {
          catppuccin = {
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "bat";
              rev = "main";
              sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
            };
            file = "Catppuccin-mocha.tmTheme";
          };
        };
        config = {
          theme = "catppuccin";
        };
      };
    };
  };
}
