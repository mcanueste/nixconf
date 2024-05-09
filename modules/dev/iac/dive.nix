# Dive: tool for exploring a docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image 
#
# https://github.com/wagoodman/dive
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    dive = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dive";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.dive {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.dive
      ];
    };
  };
}
