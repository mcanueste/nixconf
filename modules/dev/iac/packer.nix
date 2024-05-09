# Packer: tool for creating machine images
#
# https://github.com/hashicorp/packer
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    packer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable packer";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.packer {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.packer];
    };
  };
}
