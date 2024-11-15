{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      folding = true;

      settings = {
        indent.enable = true;
        highlight.enable = true;
        # incremental_selection = {
        #   enable = true;
        #   keymaps = {
        #     init_selection = "gnn";
        #     node_incremental = "<C-Space>";
        #     scope_incremental = "<C-Space>";
        #     node_decremental = "<Bspc>";
        #   };
        # };
      };

      # disable folding by default
      luaConfig.post =
        # lua
        ''
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

    hmts.enable = true;
  };
}
