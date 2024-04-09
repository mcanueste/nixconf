# Dive: tool for exploring a docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image 
#
# https://github.com/wagoodman/dive
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    dive = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dive";
    };
  };

  config = lib.mkIf config.nixconf.iac .dive {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.dive
      ];
    };
  };
}
