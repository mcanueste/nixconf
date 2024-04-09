# K9s: A terminal-based UI to interact with Kubernetes clusters
#
# https://github.com/derailed/k9s
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
  options.nixconf.iac = {
    k9s = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k9s";
    };
  };

  config = lib.mkIf config.nixconf.iac.k9s {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.k9s
      ];
      xdg.configFile."k9s/skin.yml".text = builtins.readFile "${theme}/k9s/catppuccin-mocha.yaml";
    };
  };
}
