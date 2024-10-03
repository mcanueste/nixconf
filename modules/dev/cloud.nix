{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.cloud = {
    aws = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AWS CLI";
    };

    azure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Azure CLI";
    };

    cfssl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CloudFlare SSL CLI";
    };

    digital-ocean = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Digital Ocean CLI";
    };

    gcloud = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GCloud CLI";
    };

    localstack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = {
    home-manager.users.${config.nixconf.os.user} = {
      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.dev.cloud.aws
          then pkgs.awscli2
          else null
        )

        (
          if config.nixconf.dev.cloud.azure
          then pkgs.azure-cli
          else null
        )

        (
          if config.nixconf.dev.cloud.cfssl
          then pkgs.cfssl
          else null
        )

        (
          if config.nixconf.dev.cloud.digital-ocean
          then pkgs.doctl
          else null
        )

        (
          if config.nixconf.dev.cloud.gcloud
          then
            (pkgs.google-cloud-sdk.withExtraComponents [
              pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
              pkgs.google-cloud-sdk.components.kubectl-oidc
              pkgs.google-cloud-sdk.components.terraform-tools
              pkgs.google-cloud-sdk.components.docker-credential-gcr
            ])
          else null
        )

        (
          if config.nixconf.dev.cloud.localstack
          then pkgs.localstack
          else null
        )
      ];
    };
  };
}
