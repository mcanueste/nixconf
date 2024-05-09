{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    audacity = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Audacity";
    };
  };

  config = lib.mkIf config.nixconf.media.audacity {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.audacity];
    };
  };
}
