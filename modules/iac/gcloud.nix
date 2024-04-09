# gcloud CLI
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    gcloud = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GCloud CLI";
    };
  };

  config = lib.mkIf config.nixconf.iac.gcloud {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        (pkgs.google-cloud-sdk.withExtraComponents [
          pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
          pkgs.google-cloud-sdk.components.kubectl-oidc
          pkgs.google-cloud-sdk.components.terraform-tools
          pkgs.google-cloud-sdk.components.docker-credential-gcr
        ])
      ];
    };
  };
}
