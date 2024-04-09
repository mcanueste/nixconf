# minikube for local k8s development
#
# https://github.com/kubernetes/minikube
#
# See also:
# https://nixos.wiki/wiki/Kubernetes
# https://github.com/justinas/nixos-ha-kubernetes
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    minikube = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.iac.minikube {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.minikube
      ];
    };
  };
}
