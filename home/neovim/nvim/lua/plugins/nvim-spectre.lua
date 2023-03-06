return {
  "windwp/nvim-spectre",
  -- stylua: ignore
  keys = {
    { "<leader>sr", false },
    { "<leader>os", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
  },
}
