# terraform iac
#
# https://github.com/hashicorp/terraform
#
# See also:
# https://github.com/nix-community/terraform-nixos
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
  options.nixconf.dev.iac = {
    terraform = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terraform";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.terraform {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.terraform];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
