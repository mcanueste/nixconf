{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    fzf = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fzf";
    };
  };

  config = lib.mkIf config.nixconf.term.fzf {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = config.nixconf.term.zsh;
      enableFishIntegration = config.nixconf.term.fish;
      tmux.enableShellIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'"
      ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = ["--preview '${pkgs.tree}/bin/tree -C {} | head -200'"];
    };
  };
}
