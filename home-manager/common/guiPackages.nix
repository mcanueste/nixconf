{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.guiPackages = {
    godot = lib.mkEnableOption "Godot 4";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.godot pkgs.godot_4)
    ];
  };
}
