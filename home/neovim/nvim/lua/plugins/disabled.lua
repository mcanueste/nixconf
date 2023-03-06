return {
  { "akinsho/bufferline.nvim", enabled = false },
  { "ggandor/flit.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false, },
  {
    "folke/noice.nvim",
    enabled = false
    -- stylua: ignore
    -- keys = {
    --   { "<leader>snl", false },
    --   { "<leader>snh", false },
    --   { "<leader>sna", false },
    --   { "<leader>unl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    --   { "<leader>unh", function() require("noice").cmd("history") end, desc = "Noice History" },
    --   { "<leader>una", function() require("noice").cmd("all") end, desc = "Noice All" },
    -- },
  },
}
