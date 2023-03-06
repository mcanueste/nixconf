return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>cm", false }, -- TODO remove after disabling LazyVim plugin
    { "<leader>om", "<cmd>Mason<cr>", desc = "Mason" },
  },
  opts = {
    ensure_installed = {
      -- sh/bash
      -- "shfmt",
      "beautysh",
      "shellharden",
      "shellcheck",
      "bash-language-server",

      -- json
      "json-lsp",

      -- sql
      "sql-formatter",
      "sqls",

      -- toml
      "taplo",

      -- yaml
      "yamlfmt",
      "yamllint",
      "yaml-language-server",

      -- docker
      -- "hadolint",
      "docker-compose-language-service",
      "dockerfile-language-server",

      -- ansible
      "ansible-lint",
      "ansible-language-server",

      -- terraform
      "terraform-ls",

      -- lua
      "stylua",
      "lua-language-server",

      -- js
      "typescript-language-server",

      -- go
      "gofumpt",
      "goimports",
      "golines",
      "golangci-lint",
      "gopls",

      -- rust
      "rustfmt",
      "rust-analyzer",

      -- python
      "black",
      "ruff",
      "ruff-lsp",
      "pyright",
      "mypy",

      -- nix
      "nil",

      -- markdown
      "cbfmt",
      "vale",
      "marksman",

      -- spelling
      -- "cspell",
      -- "codespell",
      -- "misspell",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    for _, tool in ipairs(opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
