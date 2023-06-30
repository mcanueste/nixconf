return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        -- ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+code" },
        ["<leader>gf"] = { name = "+fuzzy" },
        ["<leader>l"] = { name = "+lists" },
        ["<leader>v"] = { name = "+vcs" },
        ["<leader>vf"] = { name = "+fuzzy" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>o"] = { name = "+open" },
      }
      wk.register(keymaps)
    end,
}
