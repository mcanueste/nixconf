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
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.minikube
      ];
    };
  };
}
