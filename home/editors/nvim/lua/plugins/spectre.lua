-- search/replace in multiple files
return {
  "windwp/nvim-spectre",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    { "<leader>os", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
  },
}
