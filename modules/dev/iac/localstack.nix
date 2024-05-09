# localstack: emulate AWS for local dev
#
# https://github.com/localstack/localstack
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    localstack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.localstack {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.localstack
      ];
    };
  };
}
