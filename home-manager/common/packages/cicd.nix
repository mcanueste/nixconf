{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    argo = lib.mkEnableOption "Argo CLI";
    argocd = lib.mkEnableOption "ArgoCD CLI";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.argo pkgs.argo)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.argocd pkgs.argocd)
    ];
  };
}
