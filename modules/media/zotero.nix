{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    zotero = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zotero";
    };
  };

  config = lib.mkIf config.nixconf.media.zotero {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.zotero];
    };
  };
}
