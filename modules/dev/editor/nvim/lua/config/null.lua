local function init()
    -- Null-ls for missing formatting/linting
    -- See: https://github.com/nvimtools/none-ls.nvim
    local nls = require("null-ls")
    nls.setup({
        sources = {
            -- lua
            nls.builtins.formatting.stylua,

            -- bash
            -- nls.builtins.formatting.beautysh,
            -- nls.builtins.formatting.shellharden,
            -- nls.builtins.code_actions.shellcheck,

            -- docker
            -- nls.builtins.diagnostics.hadolint,

            -- terraform
            -- nls.builtins.formatting.terraform_fmt,
            -- nls.builtins.diagnostics.terraform_validate,
            -- nls.builtins.diagnostics.tfsec,

            -- python
            -- nls.builtins.formatting.black,
            -- nls.builtins.formatting.ruff,
            -- nls.builtins.formatting.djhtml,
            -- nls.builtins.diagnostics.mypy,

            -- go
            -- nls.builtins.formatting.gofumpt,
            -- nls.builtins.code_actions.golines,
            -- nls.builtins.code_actions.gomodifytags,
            -- nls.builtins.code_actions.impl,
            -- nls.builtins.code_actions.refactoring, -- install if needed

            -- yaml
            -- nls.builtins.formatting.yamlfmt,

            -- nls.builtins.formatting.prettier, -- generic formatting
        },
    })
end

return { init = init }
