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
    vscode = lib.mkEnableOption "VSCode";
    obsidian = lib.mkEnableOption "Obsidian";
    godot = lib.mkEnableOption "Godot 4";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.obsidian pkgs.obsidian)
      (pkgs.libExt.mkIfElseNull config.nixconf.editor.godot pkgs.godot_4)
    ];
  };
}
