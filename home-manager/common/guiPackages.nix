{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.guiPackages = {
    # Flatpak is buggy on wayland with xdg-desktop-portal so we install some apps natively

    spotify = lib.mkEnableOption "Spotify";

    obsidian = lib.mkEnableOption "Obsidian";

    godot = lib.mkEnableOption "Godot 4";

    slack = lib.mkEnableOption "Slack";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.spotify pkgs.spotify)
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.obsidian pkgs.obsidian)
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.godot pkgs.godot_4)
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.slack pkgs.slack)
    ];
  };
}
