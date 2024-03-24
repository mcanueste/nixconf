{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = pkgs.catppuccin.override {
    accent = "sky";
    variant = "mocha";
    themeList = ["k9s"];
  };
in {
  options.nixconf.tools = {
    k9s = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k9s";
    };
  };

  config = lib.mkIf config.nixconf.tools.k9s {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.k9s
      ];
      xdg.configFile."k9s/skin.yml".text = builtins.readFile "${theme}/k9s/catppuccin-mocha.yaml";
    };
  };
}
