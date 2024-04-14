# Digial Ocean CLI
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    digital-ocean = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Digital Ocean CLI";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.digital-ocean {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.doctl
      ];
    };
  };
}
