# Cloudflare Tools
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac = {
    cfssl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CloudFlare SSL CLI";
    };
  };

  config = lib.mkIf config.nixconf.iac.cfssl {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.cfssl
      ];
    };
  };
}
