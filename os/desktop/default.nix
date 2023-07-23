{
  imports = [
    ./greetd.nix
    ./gnome.nix
    ./i3.nix
    ./sway.nix
  ];

  security.polkit.enable = true;
  programs.light.enable = true;
}
