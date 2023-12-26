{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.browser = {
    brave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Brave browser";
    };
    firefox = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Firefox browser";
    };
    chrome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Chrome browser";
    };
  };

  config = {
    home.packages = lib.lists.flatten [
      (lib.lists.optional config.nixconf.browser.brave pkgs.brave)
      (lib.lists.optional config.nixconf.browser.firefox pkgs.firefox)
      (lib.lists.optional config.nixconf.browser.chrome pkgs.google-chrome)
    ];
  };
}
