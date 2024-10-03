{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.cicd = {
    argo = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Argo CLI";
    };

    argocd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ArgoCD CLI";
    };
  };

  config = {
    home-manager.users.${config.nixconf.username} = {
      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.dev.cicd.argo
          then pkgs.argo
          else null
        )

        (
          if config.nixconf.dev.cicd.argocd
          then pkgs.argocd
          else null
        )
      ];
    };
  };
}
