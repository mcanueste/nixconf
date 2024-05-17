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

        -- enable refactor plugin
        refactor = {
            highlight_current_scope = { enable = false }, -- we use ts-context and indentscope
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
            },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<leader>er", -- add to 'edit' prefix TODO: different from lsp one?
                },
            },
        },
        textobjects = { -- TODO: might replace with another lightweight plugin instead?
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>lS"] = "@parameter.inner",
                },
            },
        },
    })
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false -- disable folds by default
    vim.g.skip_ts_context_commentstring_module = true -- disable backwards compat for commentstring

    -------------------------------------------- TS Context setup
    require("treesitter-context").setup({
        max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        multiline_threshold = 5, -- Maximum number of lines to show for a single context
        zindex = 20, -- The Z-index of the context window
    })
end

return { init = init }
