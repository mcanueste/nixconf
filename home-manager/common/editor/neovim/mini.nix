{
  programs.nixvim.plugins = {
    mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        basics = {
          options = {
            extra_ui = true;
            win_borders = "bold";
          };
          mappings = {
            option_toggle_prefix = "<leader>t";
            windows = true;
            move_with_alt = true; # move with alt + hjkl in insert and term mode
          };
        };
        ai = {};
        bufremove = {};
        comment = {};
        diff = {};
        icons = {};
        move = {};
        indentscope.symbol = "│";
        splitjoin.mappings.toggle = "<leader>ej";
        operators = {
          evaluate.prefix = "<leader>ee";
          exchange.prefix = "<leader>ex";
          multiply.prefix = "<leader>em";
          replace.prefix = "<leader>er";
          sort.prefix = "<leader>es";
        };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
        bracketed = {
          buffer.suffix = "b";
          comment.suffix = "c";
          conflict.suffix = "x";
          diagnostic.suffix = "d";
          jump.suffix = "j";
          indent.suffix = ""; # using indentscope instead
          location.suffix = ""; # using trouble instead
          quickfix.suffix = ""; # using trouble instead
          file.suffix = ""; # not using
          oldfile.suffix = ""; # not using
          treesitter.suffix = ""; # not using
          undo.suffix = ""; # not using
          window.suffix = ""; # not using
          yank.suffix = ""; # not using
        };
      };
      luaConfig.post =
        #lua
        ''
          -- delete mini.basics binding for sys clipboard yank and paste (using global clipboard)
          vim.keymap.del({ "n", "x" }, "gy")
          vim.keymap.del({ "n", "x" }, "gp")
        '';
    };
  };
}
