{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.guiPackages = {
    # Flatpak of spotify is buggy with wayland when using `xdg-desktop-portal-*`
    spotify = lib.mkEnableOption "Spotify";

    godot = lib.mkEnableOption "Godot 4";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.spotify pkgs.spotify)
      (pkgs.libExt.mkIfElseNull config.nixconf.guiPackages.godot pkgs.godot_4)
    ];
  };
}
