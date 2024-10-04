{
  pkgs,
  config,
  lib,
  ...
}: {
  options.nixconf.term = {
    zsh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh";
    };
  };

  config = lib.mkIf config.nixconf.term.zsh {
    environment.pathsToLink = ["/share/zsh"];

    home-manager.users.${config.nixconf.username} = {
      xdg.configFile."zsh/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh".source =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "zsh-syntax-highlighting";
          rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
          sha256 = "Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
        }
        + "/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        dotDir = ".config/zsh";

        history = {
          size = 100000;
          save = 100000;
          ignoreDups = true;
          ignoreAllDups = true;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
          extended = true;
          share = true;
          ignorePatterns = ["exit" "ls" "bg" "fg" "history" "clear"];
        };

        historySubstringSearch.enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
          # Prevent file overwrite on stdout redirection
          # Use `>|` to force redirection to an existing file
          set -o noclobber

          # Warn if closing shell with running jobs.
          set -o check_jobs

          # Enable history expansion with space
          # E.g. typing !!<space> will replace the !! with your last command
          bindkey " " magic-space

          ## SMARTER TAB-COMPLETION (Readline bindings) ##

          # Perform file completion in a case insensitive fashion
          # Treat hyphens and underscores as equivalent
          zstyle ":completion:*" matcher-list "" "m:{a-zA-Z-_}={A-Za-z_-}"

          # Catppuccin Syntax Highlighting
          source ~/.config/zsh/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
        '';

        sessionVariables = {
          # Automatically trim long paths in the prompt (requires Bash 4.x)
          PROMPT_DIRTRIM = 2;
          # Record each line as it gets issued
          PROMPT_COMMAND = "history -a";
          # Use standard ISO 8601 timestamp
          # %F equivalent to %Y-%m-%d
          # %T equivalent to %H:%M:%S (24-hours format)
          HISTTIMEFORMAT = "%F %T ";
        };
      };
    };
  };
}
