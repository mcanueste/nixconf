return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim",       lazy = true },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim",        lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat",            event = "VeryLazy" },

  -- adjust shiftwidth and expandtab based on heuristics and editorconf
  { "tpope/vim-sleuth",            event = "VeryLazy" },

  -- calculate startup time
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    event = "VeryLazy",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
