{
  inputs,
  config,
  ...
}: {
  catppuccin.flavour = "mocha";
  # maybe more OS catppuccin themes in the future

  home-manager.users.${config.nixconf.user} = {
    imports = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    catppuccin.flavour = "mocha";
    catppuccin.accent = "sky";
    programs.alacritty.catppuccin.enable = true;
    programs.bat.catppuccin.enable = true;
    programs.git.delta.catppuccin.enable = true;
    programs.fish.catppuccin.enable = true;
    programs.fzf.catppuccin.enable = true;
    wayland.windowManager.hyprland.catppuccin.enable = true;
    programs.k9s.catppuccin.enable = true;
    programs.lazygit.catppuccin.enable = true;
    programs.rofi.catppuccin.enable = true;
    programs.starship.catppuccin.enable = true;
    programs.tmux.catppuccin.enable = true;
  };
}
