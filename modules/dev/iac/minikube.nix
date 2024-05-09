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
  options.nixconf.dev.iac = {
    minikube = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.minikube {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.minikube
      ];
    };
  };
}
