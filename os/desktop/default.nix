{
  imports = [
    ./gnome.nix
    ./i3.nix
  ];

  security.polkit.enable = true;
  programs.light.enable = true;
}
