{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.desktop;
  common = import ./common.nix {inherit pkgs lib config;};
in {
  options.nixhome.desktop = {
    sway = mkBoolOption {description = "Enable sway config";};
  };

  config = lib.mkIf cfg.sway {
    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      config = rec {
        inherit
          (common)
          modifier
          terminal
          workspaceAutoBackAndForth
          defaultWorkspace
          modes
          window
          floating
          focus
          fonts
          gaps
          colors
          ;

        menu = "${pkgs.wofi}/bin/wofi";
        bars = [{command = "${pkgs.waybar}/bin/waybar";}];
        input = {
          "*" = {
            xkb_layout = "us,de";
            xkb_model = "pc105";
            xkb_options = "caps:swapescape,grp:win_space_toggle";
          };
        };
        output = {"*" = {bg = "${./wallpaper.png} fill";};};
        keybindings =
          common.keybindings
          // {
            "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Do you want to exit?' -b 'Yes' 'swaymsg exit'";
            "${modifier}+Escape" = "exec ${pkgs.swaylock}/bin/swaylock";
          };
        startup = [
          {
            command = "${pkgs.blueman}/bin/blueman-applet";
            always = true;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            always = true;
          }
        ];
      };
    };
  };
}
