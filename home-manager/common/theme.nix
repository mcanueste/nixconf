{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  options.nixconf.theme = {
    font = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono";
      description = "Main font";
    };

    flavor = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
      description = "Catppuccin flavor";
    };

    accent = lib.mkOption {
      type = lib.types.str;
      default = "blue";
      description = "Catppuccin accent";
    };
  };

  config = {
    fonts.fontconfig.enable = true;
    home.packages = [
      (pkgs.nerdfonts.override {fonts = [config.nixconf.theme.font];})
    ];

    catppuccin.flavor = config.nixconf.theme.flavor;
    catppuccin.accent = config.nixconf.theme.accent;
  };
}
