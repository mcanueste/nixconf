{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    tmux = pkgs.libExt.mkEnabledOption "tmux";
  };

  config = lib.mkIf config.nixconf.term.tmux {
    programs.tmux = let
      shell =
        if config.nixconf.shell.fish
        then "${pkgs.fish}/bin/fish"
        else "${pkgs.bash}/bin/bash";
    in {
      inherit shell;
      enable = true;
      mouse = true;
      baseIndex = 1;
      keyMode = "vi";
      prefix = "M-a"; # we use alt for tmux stuff
      clock24 = false;
      escapeTime = 0;
      newSession = true;
      reverseSplit = false; # conflicts with pane_current_path bindings
      historyLimit = 500000;
      aggressiveResize = true;
      terminal = "tmux-256color";
      disableConfirmationPrompt = true;
      customPaneNavigationAndResize = true;
      sensibleOnTop = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
        tmuxPlugins.continuum
        tmuxPlugins.resurrect
      ];
      # we need session switcher
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'
        set-option -g focus-events on

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind C-l send-keys 'C-l'

        bind -N "Split vertical" v split-window -h -c "#{pane_current_path}"
        bind -N "Split horizontal" s split-window -v -c "#{pane_current_path}"
        bind -N "Move to previous window" h previous-window
        bind -N "Move to next window" l next-window
        bind -N "Move to previous session" j switch-client -n
        bind -N "Move to next session" k switch-client -p
        bind q kill-pane

        bind S new-session

        # catppuccin settings after breaking changes
        set -g status-left ""
        set -g  status-right "#{E:@catppuccin_status_session}"

        set -g @continuum-boot 'on'
        set -g @continuum-restore 'on'
      '';
    };
  };
}
