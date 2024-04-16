{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.editor = {
    datagrip = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable DataGrip";
    };
  };

  config = lib.mkIf config.nixconf.dev.editor.datagrip {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.jetbrains.datagrip];
    };
  };
}
