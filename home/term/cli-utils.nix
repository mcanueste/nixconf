{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.cli-utils;
  termCfg = config.nixhome.term;
in {
  options.nixhome.cli-utils = {
    enable = mkBoolOption {description = "Enable cli utils";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dash
      pkgs.rsync
      pkgs.gnumake
      pkgs.ripgrep
      pkgs.fd
      pkgs.htop
      pkgs.dive
      pkgs.tealdeer
      pkgs.ncdu
      pkgs.dig
      pkgs.traceroute
      pkgs.tree
      pkgs.entr
    ];
    programs.exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        prettybat
        batgrep

        # requires config - TODO
        # batwatch
        # batpipe
        # batman
        # batdiff
      ];
      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "main";
            sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
      config = {
        theme = "catppuccin";
      };
    };
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'"
      ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = ["--preview '${pkgs.tree}/bin/tree -C {} | head -200'"];
      tmux.enableShellIntegration = true;
      colors = {
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
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
    };
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };
    # home.sessionVariables = {
    #   EDITOR = "nvim";
    # };
    # systemd.user.sessionVariables = {
    #   EDITOR = "nvim";
    # };
    programs.bash = {
      shellAliases = {
        pretty = "prettybat";
        brg = "batgrep";
      };
      # sessionVariables = {
      #   EDITOR = "nvim";
      # };
    };
    programs.fish = {
      shellAliases = {
        pretty = "prettybat";
        brg = "batgrep";
      };
    };
  };
}
