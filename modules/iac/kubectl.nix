# kubectl for interacting with kubernetes clusters
#
# https://github.com/kubernetes/kubectl
{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    k = "kubectl";
  };
in {
  options.nixconf.iac = {
    kubectl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kubectl";
    };
  };

  config = lib.mkIf config.nixconf.iac.kubectl {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.kubectl];
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
