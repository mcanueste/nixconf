{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.editor = {
    gimp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GIMP";
    };
    datagrip = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable DataGrip";
    };
    pycharm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable PyCharm";
    };
    vscode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VSCode";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        (lib.lists.optional config.nixconf.editor.gimp pkgs.gimp)
        (lib.lists.optional config.nixconf.editor.datagrip pkgs.jetbrains.datagrip)
        (lib.lists.optional config.nixconf.editor.pycharm pkgs.jetbrains.pycharm-professional)
        (lib.lists.optional config.nixconf.editor.vscode pkgs.vscode)
      ];
    };
  };
}
