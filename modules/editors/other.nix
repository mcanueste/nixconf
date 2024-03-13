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
    obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Obsidian";
    };
  };

  config = {
    # obsidian 1.4.16 depends on this EOL electron?????
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-24.8.6"
    ];
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        (lib.lists.optional config.nixconf.editor.gimp pkgs.gimp)
        (lib.lists.optional config.nixconf.editor.datagrip pkgs.jetbrains.datagrip)
        (lib.lists.optional config.nixconf.editor.pycharm pkgs.jetbrains.pycharm-professional)
        (lib.lists.optional config.nixconf.editor.vscode pkgs.vscode)
        # Remove this override if obsidian releases with Electron 27...
        (lib.lists.optional config.nixconf.editor.obsidian (pkgs.obsidian.override {electron = pkgs.electron_24;}))
      ];
    };
  };
}
