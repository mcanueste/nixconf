{
  programs.nixvim = {
    clipboard = {
      register = "unnamedplus"; # sync with system clipboard `vim.g.clipboard = "unnamedplus",`
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
        xsel.enable = true;
      };
    };

    opts = {
      sessionoptions = ["buffers" "curdir" "tabpages" "winsize"];
      inccommand = "nosplit"; # preview incremental substitute
      autowrite = true; # Enable auto write

      grepformat = "%f:%l:%c:%m"; # Formatting of :grep
      grepprg = "rg --vimgrep"; # :grep command to use

      expandtab = true; # Use spaces instead of tabs
      shiftround = true; # Round indent
      shiftwidth = 2; # Size of an indent
      tabstop = 2; # Number of spaces tabs count for
      relativenumber = true; # Relative line numbers

      sidescrolloff = 8; # Columns of context
      scrolloff = 10; # Rows of context
      conceallevel = 1;

      list = false; # hide listchars

      spell = false; # disable by default
      spelllang = ["en"];

      timeout = true;
      timeoutlen = 500;

      undolevels = 10000; # keep longer undo history
      swapfile = false; # don't use swapfiles

      wildmode = "longest:full,full"; # Command-line completion mode

      formatoptions = "jql1tcron";

      laststatus = 3; # Always show status line (a single instance for different panes)
    };

    extraConfigLuaPre = ''
      vim.opt.isfname:append("@-@") -- Filename for gf and other file commands
    '';
  };
}
