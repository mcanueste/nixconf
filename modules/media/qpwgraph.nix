{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    qpwgraph = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable qpwgraph";
    };
  };

  config = lib.mkIf config.nixconf.media.qpwgraph {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.qpwgraph];
    };
  };
}
