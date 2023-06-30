return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "g\\",
      function()
        vim.lsp.buf.format()
      end,
      desc = "Format",
    },
  },
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        -- generic formatting
        -- nls.builtins.formatting.prettier,

        -- markdown
        -- nls.builtins.code_actions.proselint,

        -- toml
        -- nls.builtins.formatting.taplo,

        -- yaml TODO: might be causing weird errors
        -- nls.builtins.diagnostics.yamllint,

        -- docker
        -- nls.builtins.diagnostics.hadolint,

        -- ansible TODO: might be causing weird errors
        -- nls.builtins.diagnostics.ansiblelint,

        -- terraform
        -- nls.builtins.formatting.terraform_fmt,
        -- nls.builtins.diagnostics.tfsec,
        -- nls.builtins.diagnostics.terraform_validate,

        -- bash
        -- nls.builtins.formatting.beautysh,
        -- nls.builtins.formatting.shellharden,
        -- nls.builtins.diagnostics.shellcheck,
        -- nls.builtins.code_actions.shellcheck,

        -- go
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.goimports,
        nls.builtins.diagnostics.golangci_lint,
        nls.builtins.diagnostics.staticheck, -- TODO do we need this?
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        -- nls.builtins.code_actions.refactoring, -- TODO

        -- rust
        -- nls.builtins.formatting.rustfmt,

        -- lua
        nls.builtins.formatting.stylua,

        -- python
        -- nls.builtins.formatting.black,
        -- nls.builtins.formatting.ruff,
        -- nls.builtins.diagnostics.ruff,
        -- nls.builtins.diagnostics.mypy,

        -- nix
        nls.builtins.formatting.alejandra,
        nls.builtins.diagnostics.statix,
        nls.builtins.code_actions.statix,
      },
    }
  end,
}
