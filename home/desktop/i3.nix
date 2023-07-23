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
    i3 = mkBoolOption {description = "Enable i3 config";};
  };

  config = lib.mkIf cfg.i3 {
    xsession.windowManager.i3 = {
      enable = true;
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
          bars
          ;

        menu = "${pkgs.rofi}/bin/rofi";
        keybindings = common.keybindings // {
          "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
          "${modifier}+Escape" = "exec ${pkgs.i3lock}/bin/i3lock --color 000000";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
        };
        startup = [
          {
            command = "${pkgs.feh}/bin/feh --bg-fill ${./wallpaper.png}";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.blueman}/bin/blueman-applet";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.alacritty}/bin/alacritty --class='_scratchpad_term'";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
}
