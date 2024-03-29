{
  pkgs,
  lib,
  config,
  ...
}: let
  shell =
    if config.nixconf.term.fish
    then "${pkgs.fish}/bin/fish"
    else "${pkgs.bash}/bin/bash";
in {
  options.nixconf.term = {
    tmux = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux";
    };
  };

  config = lib.mkIf config.nixconf.term.tmux {
    home-manager.users.${config.nixconf.user} = {
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
          tmuxPlugins.tmux-fzf
        ];
        # we need session switcher
        extraConfig = ''
          set-option -sa terminal-overrides ",xterm*:Tc"
          set-option -g status-interval 5
          set-option -g automatic-rename on
          set-option -g automatic-rename-format '#{b:pane_current_path}'

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

          set -g @continuum-restore 'on'
        '';
      };
    };
  };
}
