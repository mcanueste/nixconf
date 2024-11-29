{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./neovim.nix
    ./vscode.nix
  ];

  options.nixconf.editor = {
    obsidian = lib.mkEnableOption "Obsidian";
    godot = lib.mkEnableOption "Godot 4";
    rust-rover = lib.mkEnableOption "RustRover";
    pycharm-professional = lib.mkEnableOption "PyCharm Professional";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.obsidian pkgs.obsidian)
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.godot pkgs.godot_4)
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.pycharm-professional pkgs.jetbrains.pycharm-professional)
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.rust-rover pkgs.jetbrains.rust-rover)
    ];
  };
}
