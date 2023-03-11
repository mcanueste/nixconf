{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.cli-utils;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
in {
  options.nixhome.cli-utils = {
    enable = mkBoolOption "Enable cli utils";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rsync
      pkgs.gnumake
      pkgs.ripgrep
      pkgs.fd
      pkgs.htop
      pkgs.dive
      pkgs.tealdeer
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
