{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    tf = "terraform";
  };
in {
  options.nixconf.tools = {
    terraform = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terraform";
    };
  };

  config = lib.mkIf config.nixconf.tools.terraform {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.terraform];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
