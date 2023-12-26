{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    aws = lib.mkOption {
      type = lib.types.bool;
      default = true;
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
    home.packages = lib.lists.flatten [
      (lib.lists.optional config.nixconf.term.aws pkgs.awscli2)
      (lib.lists.optional config.nixconf.term.gcloud pkgs.google-cloud-sdk)
      (lib.lists.optional config.nixconf.term.azure pkgs.azure-cli)
      (lib.lists.optional config.nixconf.term.digital-ocean pkgs.doctl)
      (lib.lists.optional config.nixconf.term.cfssl pkgs.cfssl)
    ];
  };
}
