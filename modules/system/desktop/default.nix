{
  # Bluetooth setup
  # services.blueman.enable = true; TODO move to desktop configuration
  # setup qjackctl pavucontrol applet
  imports = [
    ./common.nix
    ./gnome.nix
    ./greetd.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
    ./hyprland.nix
  ];
}
