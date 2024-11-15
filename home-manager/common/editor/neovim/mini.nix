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
          };
        };
        ai = {};
        bufremove = {};
        comment = {};
        diff = {};
        icons = {};
        move = {};
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
        indentscope.symbol = "│";
        splitjoin.mappings.toggle = "<leader>es";
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
