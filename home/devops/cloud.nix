{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.devops.cloud;
in {
  options.nixhome.devops.cloud = {
    aws = mkBoolOption {description = "Enable AWS cli";};
    gcloud = mkBoolOption {description = "Enable GCloud CLI";};
    azure = mkBoolOption {description = "Enable Azure CLI";};
    digital-ocean = mkBoolOption {description = "Enable Digital Ocean CLI";};
    cfssl = mkBoolOption {description = "Enable CloudFlare SSL CLI";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.aws pkgs.awscli2)
      (getPackageIf cfg.gcloud pkgs.google-cloud-sdk)
      (getPackageIf cfg.azure pkgs.azure-cli)
      (getPackageIf cfg.digital-ocean pkgs.doctl)
      (getPackageIf cfg.cfssl pkgs.cfssl)
    ];
  };
}
