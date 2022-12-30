{ ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };
}
