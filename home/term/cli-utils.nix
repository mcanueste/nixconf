{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.cli-utils;
  termCfg = config.nixhome.term;
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
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
    };
    programs.direnv = {
      enable = false;
      enableBashIntegration = true;
    };
    # home.sessionVariables = {
    #   EDITOR = "nvim";
    # };
    # systemd.user.sessionVariables = {
    #   EDITOR = "nvim";
    # };
    programs.bash = {
      shellAliases = {
        pretty = "prettybat";
        brg = "batgrep";
      };
      # sessionVariables = {
      #   EDITOR = "nvim";
      # };
    };
    programs.fish = {
      shellAliases = {
        pretty = "prettybat";
        brg = "batgrep";
      };
    };
  };
}
