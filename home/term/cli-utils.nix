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
    ];
    programs.exa = {
      enable = true;
      enableAliases = true;
    };
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batman
        batpipe
        batwatch
        batdiff
        prettybat
      ];
    };
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
    };
  };
}
