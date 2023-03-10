{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.tmux;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
in {
  options.nixhome.tmux = {
    enable = mkBoolOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "a";
      clock24 = true;
      escapeTime = 0;
      newSession = true;
      reverseSplit = true;
      historyLimit = 500000;
      aggressiveResize = true;
      terminal = "screen-256color";
      disableConfirmationPrompt = true;
      customPaneNavigationAndResize = true;
      extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      '';
      plugins = with pkgs; [
        tmuxPlugins.open
        tmuxPlugins.resurrect
        tmuxPlugins.continuum
        tmuxPlugins.catppuccin
      ];
    };
  };
}
