# Digial Ocean CLI
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    digital-ocean = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Digital Ocean CLI";
    };
  };

  config = lib.mkIf config.nixconf.iac.digital-ocean {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.doctl
      ];
    };
  };
}
