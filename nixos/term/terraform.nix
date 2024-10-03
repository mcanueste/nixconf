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
  options.nixconf.term = {
    terraform = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable terraform";
    };
  };

  config = lib.mkIf config.nixconf.term.terraform {
    home-manager.users.${config.nixconf.username} = {
      home.packages = [pkgs.terraform];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
