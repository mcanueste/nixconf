{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.k8s = {
    kubectl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kubectl";
    };

    k9s = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k9s";
    };

    minikube = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };

    kind = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kind";
    };

    helm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable helm";
    };
  };

  config = let
    shellAliases = {
      k = "kubectl";
    };
  in {
    home-manager.users.${config.nixconf.system.user} = {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.dev.k8s.kubectl
          then pkgs.kubectl
          else null
        )

        (
          if config.nixconf.dev.k8s.k9s
          then pkgs.k9s
          else null
        )

        (
          if config.nixconf.dev.k8s.minikube
          then pkgs.minikube
          else null
        )

        (
          if config.nixconf.dev.k8s.kind
          then pkgs.kind
          else null
        )

        (
          if config.nixconf.dev.k8s.helm
          then pkgs.kubernetes-helm
          else null
        )
      ];
    };
  };
}
