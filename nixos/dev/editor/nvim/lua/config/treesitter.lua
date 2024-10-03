local function init()
    -- treesitter.nvim setup
    -- See: https://github.com/nvim-treesitter/nvim-treesitter
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
        -- Installed via nix
        sync_install = false,
        auto_install = false,

        -- enable hightlights
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false, -- { "markdown" },
        },

        -- enable indentation support
        indent = { enable = true, disable = { "python" } },

        -- enable incremental visual selection
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = "<nop>",
                node_decremental = "<bs>",
            },
        },
    })
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false -- disable folds by default
    vim.g.skip_ts_context_commentstring_module = true -- disable backwards compat for commentstring
end

return { init = init }
