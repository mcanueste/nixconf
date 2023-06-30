-- better diagnostics list and others 
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  event = { "BufReadPost", "BufNewFile" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>ll", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>lq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").previous({ skip_groups = true, jump = true })
        else
          vim.cmd.cprev()
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          vim.cmd.cnext()
        end
      end,
      desc = "Next trouble/quickfix item",
    },
  },
}
