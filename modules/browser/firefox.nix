{
  pkgs-stable,
  lib,
  config,
  ...
}: {
  options.nixconf.browser = {
    firefox = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Firefox browser";
    };
  };

  config = lib.mkIf config.nixconf.browser.firefox {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs-stable.firefox];
    };
  };
}
