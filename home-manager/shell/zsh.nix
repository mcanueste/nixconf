{
  config,
  lib,
  ...
}: {
  options.nixconf.shell = {
    zsh = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf config.nixconf.shell.zsh {
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
      syntaxHighlighting = {
        enable = true;
        catppuccin = true;
      };

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
}
