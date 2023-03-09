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
    rsync = mkBoolOption "Enable rsync";

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

    brave = mkBoolOption "Enable brave browser";
    teams = mkBoolOption "Enable teams";
    datagrip = mkBoolOption "Enable JetBrains Datagrip";
    pycharm = mkBoolOption "Enable JetBrains PyCharm Professional";
    nerdfonts = mkBoolOption "Enable Nerd Fonts";
  };

  config = {
    home.packages = filterPkgs [
      pkgs.gnumake
      (getPkgIf cfg.htop pkgs.htop)
      (getPkgIf cfg.ripgrep pkgs.ripgrep)
      (getPkgIf cfg.fd pkgs.fd)
      (getPkgIf cfg.dive pkgs.dive)
      (getPkgIf cfg.rsync pkgs.rsync)
      (getPkgIf cfg.kubectl pkgs.kubectl)
      (getPkgIf cfg.minikube pkgs.minikube)
      (getPkgIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPkgIf cfg.cfssl pkgs.cfssl)
      (getPkgIf cfg.brave pkgs.brave)
      (getPkgIf cfg.teams pkgs.teams)
      (getPkgIf cfg.datagrip pkgs.jetbrains.datagrip)
      (getPkgIf cfg.pycharm pkgs.jetbrains.pycharm-professional)
      (
        getPkgIf cfg.nerdfonts
        (pkgs.nerdfonts.override {fonts = [
          "FiraCode" "SourceCodePro"
        ];})
      )
    ];
    fonts.fontconfig.enable = cfg.nerdfonts;
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
