{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    kubectl = lib.mkEnableOption "Kubectl";
    k9s = lib.mkEnableOption "K9s";
    k3d = lib.mkEnableOption "K3d";
    helm = lib.mkEnableOption "Helm";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.kubectl pkgs.kubectl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.k3d pkgs.k3d)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.helm pkgs.kubernetes-helm)
    ];

    programs.k9s.enable = config.nixconf.packages.k9s;
  };
}
