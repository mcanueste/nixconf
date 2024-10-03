{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.editor.pycharm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable PyCharm";
    };

    professional = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use PyCharm Professional instead of Community";
    };
  };

  config = lib.mkIf config.nixconf.dev.editor.pycharm.enable {
    home-manager.users.${config.nixconf.username} = let
      pycharm =
        if config.nixconf.dev.editor.pycharm.professional
        then pkgs.jetbrains.pycharm-professional
        else pkgs.jetbrains.pycharm-community;
    in {
      home.packages = [pycharm];
    };
  };
}
