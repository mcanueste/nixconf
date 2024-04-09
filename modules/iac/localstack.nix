# localstack: emulate AWS for local dev
#
# https://github.com/localstack/localstack
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    localstack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.iac.localstack {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.localstack
      ];
    };
  };
}
