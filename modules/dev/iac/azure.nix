# Azure CLI
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    azure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Azure CLI";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.azure {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.azure-cli
      ];
    };
  };
}
