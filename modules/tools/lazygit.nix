{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    lg = "lazygit";
  };
  theme = pkgs.catppuccin.override {
    accent = "sky";
    variant = "mocha";
    themeList = ["lazygit"];
  };
in {
  options.nixconf.tools = {
    lazygit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lazygit";
    };
  };

  config = lib.mkIf config.nixconf.tools.lazygit {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.lazygit
      ];

      xdg.configFile."lazygit/config.yml".text = builtins.readFile "${theme}/lazygit/themes/sky.yml";
    };
  };
}
