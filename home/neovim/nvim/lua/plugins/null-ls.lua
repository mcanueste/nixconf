return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        -- sh/bash
        -- nls.builtins.formatting.shfmt,
        nls.builtins.formatting.beautysh,
        nls.builtins.formatting.shellharden,
        -- nls.builtins.diagnostics.shellcheck, -- bashls
        nls.builtins.code_actions.shellcheck,

        -- sql
        -- nls.builtins.formatting.sql_formatter,

        -- yaml
        nls.builtins.formatting.yamlfmt,
        nls.builtins.diagnostics.yamllint,

        -- docker
        -- nls.builtins.diagnostics.hadolint, -- TODO

        -- ansible
        nls.builtins.diagnostics.ansiblelint,

        -- lua
        nls.builtins.formatting.stylua,

        -- go
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.golines,
        nls.builtins.diagnostics.golangci_lint,

        -- rust
        nls.builtins.formatting.rustfmt,

        -- python
        nls.builtins.formatting.black,
        nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.mypy,

        -- spelling
        -- nls.builtins.formatting.codespell,
        -- nls.builtins.diagnostics.codespell,
        -- nls.builtins.diagnostics.misspell,
        -- nls.builtins.diagnostics.cspell,
        -- nls.builtins.code_actions.cspell,

        -- markdown
        nls.builtins.formatting.cbfmt,
        nls.builtins.diagnostics.vale,

        -- nix
        nls.builtins.formatting.alejandra,
      },
    }
  end,
}
