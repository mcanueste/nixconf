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
  options.nixconf.term = {
    kubectl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kubectl";
    };
  };

  config = lib.mkIf config.nixconf.term.kubectl {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.kubectl];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
