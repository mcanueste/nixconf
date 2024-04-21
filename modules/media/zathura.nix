{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    zathura = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zathura PDF viewer";
    };
  };

  config = lib.mkIf config.nixconf.media.zathura {
    home-manager.users.${config.nixconf.user} = {
      programs.zathura = {
        enable = true;
      };
    };
  };
}
