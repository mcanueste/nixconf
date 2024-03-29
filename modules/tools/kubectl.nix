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
  options.nixconf.tools = {
    kubectl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kubectl";
    };
  };

  config = lib.mkIf config.nixconf.tools.kubectl {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.kubectl];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
