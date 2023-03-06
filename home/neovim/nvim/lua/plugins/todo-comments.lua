return {
  "folke/todo-comments.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>xt", false },
    { "<leader>xT", false },
    { "<leader>st", false },
    { "<leader>lt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>lT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  },
}
