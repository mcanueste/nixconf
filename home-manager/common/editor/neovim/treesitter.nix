{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      folding = true;

      # disable folding by default
      luaConfig.post = ''
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false -- disable folds by default
      '';
    };

    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 4;
        multiline_threshold = 4;
      };
    };

    hmts.enable = true; # FIXME: not working?
  };
}
