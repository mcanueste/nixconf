{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.fzf;
  termCfg = config.nixhome.term;
in {
  options.nixhome.tools.fzf = {
    enable = mkBoolOption {description = "Enable fzf";};
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
      tmux.enableShellIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'"
      ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = ["--preview '${pkgs.tree}/bin/tree -C {} | head -200'"];
      colors = {
        # catppuccin theme
        "bg+" = "#313244";
        bg = "#1e1e2e";
        spinner = "#f5e0dc";
        hl = "#f38ba8";
        fg = "#cdd6f4";
        header = "#f38ba8";
        info = "#cba6f7";
        pointer = "#f5e0dc";
        marker = "#f5e0dc";
        "fg+" = "#cdd6f4";
        prompt = "#cba6f7";
        "hl+" = "#f38ba8";
      };
    };
  };
}
