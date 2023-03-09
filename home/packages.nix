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
  filterPkgs = builtins.filter (p: p != null);
in {
  options.nixhome.packages = {
    kubectl = mkBoolOption "Enable kubectl";
    minikube = mkBoolOption "Enable minikube";
    gcloud = mkBoolOption "Enable gcloud cli";
    cfssl = mkBoolOption "Enable CloudFlare SSL CLI";
    tmux = mkBoolOption "Enable tmux";
    brave = mkBoolOption "Enable brave browser";
    teams = mkBoolOption "Enable teams";
    datagrip = mkBoolOption "Enable JetBrains Datagrip";
    pycharm = mkBoolOption "Enable JetBrains PyCharm Professional";
  };

  config = {
    home.packages = filterPkgs [
      (getPkgIf cfg.kubectl pkgs.kubectl)
      (getPkgIf cfg.minikube pkgs.minikube)
      (getPkgIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPkgIf cfg.cfssl pkgs.cfssl)
      (getPkgIf cfg.brave pkgs.brave)
      (getPkgIf cfg.teams pkgs.teams)
      (getPkgIf cfg.datagrip pkgs.jetbrains.datagrip)
      (getPkgIf cfg.pycharm pkgs.jetbrains.pycharm-professional)
    ];
    programs.tmux = {
      enable = cfg.tmux;
    };
  };
}
