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
    home.packages = [
      # screenshot
      pkgs.grim
      pkgs.slurp
      pkgs.swappy

      pkgs.pcmanfm # file manager
    ];
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
            # xkb_options = "caps:swapescape,grp:win_space_toggle";
            xkb_options = "caps:escape,grp:win_space_toggle";
          };
        };
        output = {"*" = {bg = "${./wallpaper.png} fill";};};
        keybindings =
          common.keybindings
          // {
            "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Do you want to exit?' -b 'Yes' 'swaymsg exit'";
            "${modifier}+Escape" = "exec ${pkgs.swaylock}/bin/swaylock";

            # Screenshot
            "Print" = ''exec grim -g "$(slurp)" $HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png'';
            "Shift+Print" = ''exec grim -g "$(slurp)" - | swappy -o $HOME/Pictures/Screenshots/$(date -u +'%Y%m%d-%H%M%SZ').png -f -'';

            ## Screen recording
            # "${modifier}+Print" = "exec wayrecorder --notify screen";
            # "${modifier}+Shift+Print" = "exec wayrecorder --notify --input area";
            # "${modifier}+Alt+Print" = "exec wayrecorder --notify --input active";
            # "${modifier}+Shift+Alt+Print" = "exec wayrecorder --notify --input window";
            # "${modifier}+Ctrl+Print" = "exec wayrecorder --notify --clipboard --input screen";
            # "${modifier}+Ctrl+Shift+Print" = "exec wayrecorder --notify --clipboard --input area";
            # "${modifier}+Ctrl+Alt+Print" = "exec wayrecorder --notify --clipboard --input active";
            # "${modifier}+Ctrl+Shift+Alt+Print" = "exec wayrecorder --notify --clipboard --input window";
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
