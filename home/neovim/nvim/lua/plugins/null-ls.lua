return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        -- generic formatting
        nls.builtins.formatting.prettier,

        -- markdown
        nls.builtins.diagnostics.vale,
        nls.builtins.code_actions.proselint,

        -- toml
        nls.builtins.formatting.taplo,

        -- yaml
        nls.builtins.diagnostics.yamllint,

        -- docker
        nls.builtins.diagnostics.hadolint,

        -- ansible
        nls.builtins.diagnostics.ansiblelint,

        -- terraform
        nls.builtins.formatting.terraform_fmt,
        nls.builtins.diagnostics.tfsec,
        nls.builtins.diagnostics.terraform_validate,

        -- bash
        nls.builtins.formatting.beautysh,
        nls.builtins.formatting.shellharden,
        nls.builtins.diagnostics.shellcheck,
        nls.builtins.code_actions.shellcheck,

        -- go
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.goimports,
        nls.builtins.diagnostics.golangci_lint,

        -- rust
        nls.builtins.formatting.rustfmt,

        -- lua
        nls.builtins.formatting.stylua,

        -- python
        nls.builtins.formatting.black,
        nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.ruff,
        nls.builtins.diagnostics.mypy,

        -- nix
        nls.builtins.formatting.alejandra,
        nls.builtins.diagnostics.statix,
        nls.builtins.code_actions.statix,
      },
    }
  end,
  keys = {
    { "<leader>cf", function() vim.lsp.buf.format() end, desc = "Format" },
  },
}
