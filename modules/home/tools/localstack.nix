{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.tools = {
    localstack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.tools.localstack {
    home.packages = [
      pkgs.localstack
    ];
  };
}
