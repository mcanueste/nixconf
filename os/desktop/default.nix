{
  imports = [
    ./gnome.nix
    ./i3.nix
    ./greetd.nix
  ];

  security.polkit.enable = true;
  programs.light.enable = true;
}
