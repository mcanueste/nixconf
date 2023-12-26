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
    obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Obsidian";
    };
  };

  config = {
    home.packages = lib.lists.flatten [
      (lib.lists.optional config.nixconf.editor.gimp pkgs.gimp)
      (lib.lists.optional config.nixconf.editor.datagrip pkgs.jetbrains.datagrip)
      (lib.lists.optional config.nixconf.editor.pycharm pkgs.jetbrains.pycharm-professional)
      (lib.lists.optional config.nixconf.editor.obsidian pkgs.obsidian)
    ];
  };
}
