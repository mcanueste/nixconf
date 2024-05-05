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
  # size = "standard";
  # gtkTheme = "dark";
  #
  # mkUpper = str:
  #   with builtins;
  #     (pkgs.lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  #
  # flavorUpper = mkUpper flavor;
  # accentUpper = mkUpper accent;
  # sizeUpper = mkUpper size;
  # gtkThemeUpper = mkUpper gtkTheme;
in {
  catppuccin.flavour = flavor;
  # maybe more OS catppuccin themes in the future

  home-manager.users.${config.nixconf.user} = {
    imports = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    fonts.fontconfig.enable = true;
    home.packages = [nerdFonts];
    catppuccin.flavour = flavor;
    catppuccin.accent = accent;

    programs.bat.catppuccin.enable = true;
    programs.git.delta.catppuccin.enable = true;
    programs.fish.catppuccin.enable = true;
    programs.fzf.catppuccin.enable = true;
    programs.k9s.catppuccin.enable = true;
    programs.lazygit.catppuccin.enable = true;
    programs.starship.catppuccin.enable = true;
    programs.tmux.catppuccin.enable = true;
    programs.yazi.catppuccin.enable = true;
    programs.zathura.catppuccin.enable = true;

    gtk = {
      # Catppuccin theme is done via catppuccin-nix
      # Catppuccin cursor theme is done via catppuccin-nix
      catppuccin.enable = true;

      iconTheme = {
        name = "Papirus-Dark"; # folder icons are modified
        package = pkgs.catppuccin-papirus-folders.override {
          inherit flavor accent;
        };
      };
    };

    # theming in QT is a mess (this config somehow follows gtk theming)
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

    # TODO set cursor with hyprland
    wayland.windowManager.hyprland = {
      catppuccin.enable = true;
      # settings.exec-once = [
      #   "hyprctl setcursor Catppuccin-${flavorUpper}-${sizeUpper}-${accentUpper}-${gtkThemeUpper} standard &"
      # ];
    };

    programs.rofi = {
      catppuccin.enable = true;
      font = "${mainFont} Nerd Font 14";
    };

    # SwayNC theme and font config
    xdg.configFile."swaync/style.css".text =
      if
        config.nixconf.system.desktop.enable
        && config.nixconf.system.desktop.wm.enable
        && config.nixconf.system.desktop.wm.notification.swaync
      then
        (lib.strings.replaceStrings ["Ubuntu"] ["${mainFont} Nerd Font"]
          (builtins.readFile (pkgs.fetchurl {
            url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/mocha.css";
            sha256 = "sha256-2263JSGJLu2HyHQRsFt14NSFfYj0t3h52KoE3fYL5Kc=";
          })))
      else "";

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
  };
}
