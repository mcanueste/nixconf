# Azure CLI
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    azure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Azure CLI";
    };
  };

  config = lib.mkIf config.nixconf.iac.azure {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.azure-cli
      ];
    };
  };
}
