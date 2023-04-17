{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.devops.k8s;
in {
  options.nixhome.devops.k8s = {
    kubectl = mkBoolOption {description = "Enable kubectl";};
    minikube = mkBoolOption {description = "Enable minikube";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.kubectl pkgs.kubectl)
      (getPackageIf cfg.minikube pkgs.minikube)
    ];

    programs.bash.shellAliases = {
      k = "kubectl";
    };

    programs.fish.shellAliases = {
      k = "kubectl";
    };
  };
}
