{
  pkgs-stable,
  lib,
  config,
  ...
}: {
  options.nixconf.browser = {
    chrome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Chrome browser";
    };
  };

  config = lib.mkIf config.nixconf.browser.chrome {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs-stable.google-chrome];
    };
  };
}
