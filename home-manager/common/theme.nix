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
      (pkgs.stable.nerdfonts.override {fonts = [config.nixconf.theme.font];})
    ];

    catppuccin = {
      flavor = config.nixconf.theme.flavor;
      accent = config.nixconf.theme.accent;
      yazi.enable = true;
      tmux.enable = true;
      starship.enable = true;
      lazygit.enable = true;
      k9s.enable = true;
      gh-dash.enable = true;
      fzf.enable = true;
      fish.enable = true;
      delta.enable = true;
      bat.enable = true;
      alacritty.enable = true;
    };
  };
}
