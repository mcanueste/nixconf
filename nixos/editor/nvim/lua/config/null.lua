local function init()
    -- Null-ls for missing formatting/linting
    -- See: https://github.com/nvimtools/none-ls.nvim
    local nls = require("null-ls")
    nls.setup({
        sources = {
            -- bash
            nls.builtins.formatting.shellharden,

            -- docker
            nls.builtins.diagnostics.hadolint,

            -- lua
            nls.builtins.formatting.stylua,

            -- terraform
            nls.builtins.diagnostics.tfsec,

            -- github actions
            nls.builtins.diagnostics.actionlint,
        },
    })
end

return { init = init }
