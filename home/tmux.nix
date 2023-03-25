{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tmux;
in {
  options.nixhome.tmux = {
    enable = mkBoolOption {
      description = "Enable tmux";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      settings = {
        shell = {
          program = "bash";
          args = [
            "-l"
            "-c"
            "tmux attach || tmux"
          ];
        };
      };
    };
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
