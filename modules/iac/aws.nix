# AWS CLI
#
# https://github.com/NixOS/nixops-aws
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    aws = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AWS CLI";
    };
  };

  config = lib.mkIf config.nixconf.iac.aws {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.awscli2
      ];
    };
  };
}
