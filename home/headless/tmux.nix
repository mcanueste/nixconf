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
    sensibleOnTop = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    reverseSplit = true;

    # tmuxp.enable = true;
    # tmuxinator.enable = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.cpu;
      }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore "on"
      #     set -g @continuum-save-interval "60" # minutes
      #   '';
      # }
      # { # TODO: package this or implement scripts
      #   plugin = tmuxPlugins.session-wizard;
      #   extraConfig = "set -g @session-wizard 'T'";
      # }
    ];
  };
}
