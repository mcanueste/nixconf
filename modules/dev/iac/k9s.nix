# K9s: A terminal-based UI to interact with Kubernetes clusters
#
# https://github.com/derailed/k9s
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    k9s = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k9s";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.k9s {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.k9s
      ];
    };
  };
}
