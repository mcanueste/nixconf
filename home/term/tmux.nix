{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term.tmux;
  shell = config.nixhome.term.alacritty.shell;
in {
  options.nixhome.term.tmux = {
    enable = mkBoolOption {description = "Enable tmux";};
    attachAlacritty = mkBoolOption {
      description = "Attach or create tmux session on alacritty start";
    };
  };

  config =
    lib.mkIf cfg.enable {
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
    # // (
    #   if cfg.enable && cfg.attachAlacritty
    #   then {
    #     programs.alacritty = {
    #       settings = {
    #         shell = {
    #           program = shell;
    #           args = [
    #             "-l"
    #             "-c"
    #             "tmux attach || tmux"
    #           ];
    #         };
    #       };
    #     };
    #   }
    #   else {}
    # );
}
