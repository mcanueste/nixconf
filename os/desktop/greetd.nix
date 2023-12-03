{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.desktop;
in {
  options.nixos.desktop = {
    greetd = mkBoolOption {description = "Enable greetd login manager";};
  };

  config = lib.mkIf cfg.greetd {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd sway
        '';
      };
    };
    environment.etc."greetd/environments".text = ''
      sway --unsupported-gpu
    '';
  };
}
