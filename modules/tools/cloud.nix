{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.tools = {
    aws = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AWS CLI";
    };

    gcloud = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GCloud CLI";
    };

    azure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Azure CLI";
    };

    digital-ocean = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Digital Ocean CLI";
    };

    cfssl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CloudFlare SSL CLI";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        (lib.lists.optional config.nixconf.tools.aws pkgs.awscli2)
        (lib.lists.optional config.nixconf.tools.azure pkgs.azure-cli)
        (lib.lists.optional config.nixconf.tools.digital-ocean pkgs.doctl)
        (lib.lists.optional config.nixconf.tools.cfssl pkgs.cfssl)
        (lib.lists.optional config.nixconf.tools.gcloud (pkgs.google-cloud-sdk.withExtraComponents [
          pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
          # pkgs.google-cloud-sdk.components.kubectl
          pkgs.google-cloud-sdk.components.kubectl-oidc
          pkgs.google-cloud-sdk.components.terraform-tools
          pkgs.google-cloud-sdk.components.docker-credential-gcr
        ]))
      ];
    };
  };
}
