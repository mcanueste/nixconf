{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  mainFont = "JetBrainsMono";

  nerdFonts = pkgs.nerdfonts.override {
    fonts = [
      mainFont
    ];
  };

  flavor = "mocha";
  accent = "blue";
in {
  # User Level Configuration
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  fonts.fontconfig.enable = true;
  home.packages = [nerdFonts];
  catppuccin.flavor = flavor;
  catppuccin.accent = accent;

  programs.bat.catppuccin.enable = true;
  programs.git.delta.catppuccin.enable = true;
  programs.gh-dash.catppuccin.enable = true;
  programs.fish.catppuccin.enable = true;
  programs.fzf.catppuccin.enable = true;
  programs.k9s.catppuccin.enable = true;
  programs.lazygit.catppuccin.enable = true;
  programs.starship.catppuccin.enable = true;
  programs.tmux.catppuccin.enable = true;
  programs.yazi.catppuccin.enable = true;
  programs.zathura.catppuccin.enable = true;

  gtk = {
    iconTheme = {
      name = "Papirus-Dark"; # folder icons are modified
      package = pkgs.catppuccin-papirus-folders.override {
        inherit flavor accent;
      };
    };
  };

  qt = {
    platformTheme.name = "gtk2";
    style = {
      name = "gtk2";
      package = [
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
        pkgs.libsForQt5.qtstyleplugins
        pkgs.qt6Packages.qt6gtk2
      ];
    };
  };

  programs.alacritty = let
    getFont = font: style: {
      inherit style;
      family = "${font} Nerd Font";
    };
  in {
    catppuccin.enable = true;
    settings.font = {
      normal = getFont mainFont "Regular";
      bold = getFont mainFont "Bold";
      italic = getFont mainFont "Italic";
      bold_italic = getFont mainFont "Bold Italic";
      size = 12.0;
    };
  };
}
