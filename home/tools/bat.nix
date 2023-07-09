{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.bat;
  shellAliases = {
    pretty = "prettybat";
    brg = "batgrep";
  };
in {
  options.nixhome.tools.bat = {
    enable = mkBoolOption {description = "Enable bat";};
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        prettybat
        batgrep

        # requires config - TODO
        # batwatch
        # batpipe
        # batman
        # batdiff
      ];
      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "main";
            sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
      config = {
        theme = "catppuccin";
      };
    };
  };
}
