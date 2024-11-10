{
  programs.nixvim = {
    plugins = {
      trouble.enable = true;
      todo-comments = {
        enable = true;
        keymaps.todoTrouble.key = "<leader>lt";
      };
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
      qfFunc = action: ''
        function()
          local tr = package.loaded.trouble
          if tr.is_open() then
            tr.${action} { skip_groups = true, jump = true }
          else
            vim.cmd.c${action}()
          end
        end
      '';
    in [
      (map ["n"] "[q" {__raw = qfFunc "prev";} "Trouble Prev")
      (map ["n"] "]q" {__raw = qfFunc "next";} "Trouble Next")
      (map ["n"] "<leader>ld" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics")
      (map ["n"] "<leader>lD" "<cmd>Trouble diagnostics toggle<cr>" "Workspace Diagnostics")
      (map ["n"] "<leader>lq" "<cmd>Trouble qflist toggle<cr>" "Quickfix List")
      (map ["n"] "<leader>ls" "<cmd>Trouble symbols toggle focus=false<cr>" "Symbols")
      (map ["n"] "<leader>lg" "<cmd>Trouble lsp toggle focus=false win.position=right<cr>" "Definitions/References/...")
    ];
  };
}
