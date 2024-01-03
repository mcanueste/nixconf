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
  options.nixconf.tools = {
    packer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable packer";
    };
  };

  config = lib.mkIf config.nixconf.tools.packer {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.packer];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
