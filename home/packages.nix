{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.packages;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
  getPkgIf = cond: pkg:
    if cond
    then pkg
    else null;
  filterPkgs = packages: builtins.filter (p: ! isNull p) packages;
in {
  options.nixhome.packages = {
    htop = mkBoolOption "Enable htop";
    ripgrep = mkBoolOption "Enable ripgrep";
    fd = mkBoolOption "Enable fd";
    dive = mkBoolOption "Enable dive";
    lazygit = mkBoolOption "Enable lazygit";
    rsync = mkBoolOption "Enable rsync";
    nixvim = mkBoolOption "Enable nixvim";

    kubectl = mkBoolOption "Enable kubectl";
    minikube = mkBoolOption "Enable minikube";
    gcloud = mkBoolOption "Enable gcloud cli";
    cfssl = mkBoolOption "Enable CloudFlare SSL CLI";

    exa = mkBoolOption "Enable exa";
    bat = mkBoolOption "Enable bat";
    fzf = mkBoolOption "Enable fzf";
    zoxide = mkBoolOption "Enable zoxide";
    direnv = mkBoolOption "Enable direnv";
    tmux = mkBoolOption "Enable tmux";
  };

  config = {
    home.packages = filterPkgs [
      pkgs.gnumake
      (getPkgIf cfg.htop pkgs.htop)
      (getPkgIf cfg.ripgrep pkgs.ripgrep)
      (getPkgIf cfg.fd pkgs.fd)
      (getPkgIf cfg.dive pkgs.dive)
      (getPkgIf cfg.lazygit pkgs.lazygit)
      (getPkgIf cfg.rsync pkgs.rsync)
      (getPkgIf cfg.nixvim pkgs.nixvim)
      (getPkgIf cfg.kubectl pkgs.kubectl)
      (getPkgIf cfg.minikube pkgs.minikube)
      (getPkgIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPkgIf cfg.cfssl pkgs.cfssl)
    ];
    programs.exa = {
      enable = cfg.exa;
      enableAliases = true;
    };
    programs.bat = {
      enable = cfg.bat;
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
      enable = cfg.fzf;
      enableBashIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };
    programs.zoxide = {
      enable = cfg.zoxide;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    programs.direnv = {
      enable = cfg.direnv;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = true;
    };
    programs.tmux = {
      enable = cfg.tmux;
    };
  };
}
