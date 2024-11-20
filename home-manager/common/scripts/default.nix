{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./templater.nix
    ./sync-notes.nix
    ./sync-blog.nix
  ];

  options.nixconf.scripts = {
    enable = pkgs.libExt.mkEnabledOption "Custom Scripts";
    systemd = lib.mkEnableOption "Enable user space systemd services related to scripts";
  };
}
