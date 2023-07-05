{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
  shell =
    if cfg.fish
    then "${pkgs.fish}/bin/fish"
    else "${pkgs.bash}/bin/bash";
in {
  options.nixhome.term = {
    tmux = mkBoolOption {description = "Enable tmux";};
  };

  config = lib.mkIf cfg.tmux {
    programs.tmux = {
      enable = true;
      inherit shell;
      mouse = true;
      baseIndex = 1;
      keyMode = "vi";
      prefix = "M-a"; # we use alt for tmux stuff
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
        tmuxPlugins.continuum
        tmuxPlugins.resurrect
        tmuxPlugins.catppuccin
        tmuxPlugins.vim-tmux-navigator
      ];
      # we need session switcher
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set-option -g xterm-keys on
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind C-l send-keys 'C-l'
        bind -N "Split vertical" v split-window -h -c "#{pane_current_path}"
        bind -N "Split horizontal" s split-window -v -c "#{pane_current_path}"
        bind -n M-h previous-window
        bind -n M-l next-window
        bind -n M-j switch-client -n
        bind -n M-k switch-client -p
        bind q kill-pane
      '';
    };
  };
}
