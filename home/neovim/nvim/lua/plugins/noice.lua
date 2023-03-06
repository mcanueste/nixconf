return {
  "folke/noice.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>snl", false },
    { "<leader>snh", false },
    { "<leader>sna", false },
    { "<leader>unl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>unh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>una", function() require("noice").cmd("all") end, desc = "Noice All" },
  },
}
