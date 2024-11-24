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
    notes = lib.mkEnableOption "Enable notes syncing";
    systemd = lib.mkEnableOption "Enable user space systemd services related to notes syncing";
  };
}
