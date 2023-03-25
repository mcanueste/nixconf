{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.cloud;
in {
  options.nixhome.cloud = {
    kubectl = mkBoolOption {description = "Enable kubectl";};
    minikube = mkBoolOption {description = "Enable minikube";};
    gcloud = mkBoolOption {
      description = "Enable gcloud cli";
      default = false;
    };
    cfssl = mkBoolOption {
      description = "Enable CloudFlare SSL CLI";
      default = false;
    };
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.kubectl pkgs.kubectl)
      (getPackageIf cfg.minikube pkgs.minikube)
      (getPackageIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPackageIf cfg.cfssl pkgs.cfssl)
    ];
  };
}
