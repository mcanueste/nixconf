{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # prefix = "C-a";
    shortcut = "a";

    baseIndex = 1;
    clock24 = true;

    disableConfirmationPrompt = true;
    newSession = true;
    terminal = "screen-256color";
    historyLimit = 50000;

    sensibleOnTop = true;

    keyMode = "vi";
    reverseSplit = false;
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set -g mouse on 
      set -g mouse-select-pane on

      bind -N "Split the pane into two, left and right" g split-window -h
      bind -N "Split the pane into two, top and bottom" v split-window -v
    '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };
}
