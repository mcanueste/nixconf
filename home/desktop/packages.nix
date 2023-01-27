{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  # Packages that don't need GUI and specific config
  home.packages = with pkgs; [
    brave
    teams
    zoom-us
    jetbrains.datagrip
    (pkgs.nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];
}