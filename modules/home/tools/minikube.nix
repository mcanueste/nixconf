{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.tools = {
    minikube = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minikube";
    };
  };

  config = lib.mkIf config.nixconf.tools.minikube {
    home.packages = [
      pkgs.minikube
    ];
  };
}
