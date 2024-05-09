{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.browser = {
    brave = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Brave browser";
    };
  };

  config = lib.mkIf config.nixconf.browser.brave {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.brave];
    };
  };
}
