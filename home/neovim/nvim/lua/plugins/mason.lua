return {
  "williamboman/mason.nvim",
  keys = {
    { "<leader>cm", false },
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
      -- "hadolint", -- TODO
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
}
