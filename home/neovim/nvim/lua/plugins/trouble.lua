return {
  "folke/trouble.nvim",
  keys = {
    { "<leader>xx", false },
    { "<leader>xX", false },
    { "<leader>xL", false },
    { "<leader>xQ", false },
    { "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>lL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>lQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
  },
}
