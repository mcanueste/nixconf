{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    pk = "packer";
  };
in {
  options.nixconf.term = {
    packer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable packer";
    };
  };

  config = lib.mkIf config.nixconf.term.packer {
    home.packages = [pkgs.packer];
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
  };
}
