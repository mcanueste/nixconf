{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.cloud;
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
  options.nixhome.cloud = {
    kubectl = mkBoolOption "Enable kubectl";
    minikube = mkBoolOption "Enable minikube";
    gcloud = mkBoolOption "Enable gcloud cli";
    cfssl = mkBoolOption "Enable CloudFlare SSL CLI";
  };

  config = {
    home.packages = filterPkgs [
      (getPkgIf cfg.kubectl pkgs.kubectl)
      (getPkgIf cfg.minikube pkgs.minikube)
      (getPkgIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPkgIf cfg.cfssl pkgs.cfssl)
    ];
  };
}
