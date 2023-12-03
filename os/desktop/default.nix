{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome.nix
    ./i3.nix
    ./sway.nix
  ];

  # control system wide priviledges without sudo
  security.polkit.enable = true;

  # enable britghtness control
  programs.light.enable = true;

  # Enable thunar file manager and other services for automated mounts etc.
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
