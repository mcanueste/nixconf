{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
in {
  options.nixhome.term = {
    tmux = mkBoolOption {description = "Enable tmux";};
  };

  config =
    lib.mkIf cfg.tmux {
      programs.tmux = {
        enable = true;
        mouse = true;
        baseIndex = 1;
        keyMode = "vi";
        shortcut = "a";
        clock24 = true;
        escapeTime = 0;
        newSession = true;
        reverseSplit = false; # conflicts with pane_current_path bindings
        historyLimit = 500000;
        aggressiveResize = true;
        terminal = "screen-256color";
        disableConfirmationPrompt = true;
        customPaneNavigationAndResize = true;
        sensibleOnTop = true;
        plugins = with pkgs; [
          tmuxPlugins.yank
          tmuxPlugins.vim-tmux-navigator
          tmuxPlugins.resurrect
          tmuxPlugins.continuum
          tmuxPlugins.catppuccin
        ];
        extraConfig = ''
          set -ag terminal-overrides ",xterm-256color:RGB"
          bind -n M-h previous-window
          bind -n M-l next-window
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
        '';
      };
    };
}
