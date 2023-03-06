return {
  "folke/which-key.nvim",
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    local keymaps = {
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["gz"] = { name = "+surround" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader><tab>"] = { name = "+tabs" },
      ["<leader>b"] = { name = "+buffer" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>o"] = { name = "+open" },
      ["<leader>f"] = { name = "+find" },
      ["<leader>fl"] = { name = "+lsp" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>gh"] = { name = "+hunks" },
      ["<leader>gf"] = { name = "+git" },
      ["<leader>q"] = { name = "+quit/session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>u"] = { name = "+ui" },
      ["<leader>un"] = { name = "+noice" },
      ["<leader>w"] = { name = "+windows" },
      ["<leader>l"] = { name = "+lists" },
    }
    wk.register(keymaps)
  end,
}
