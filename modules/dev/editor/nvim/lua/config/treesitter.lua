local treesitter = require("nvim-treesitter.configs")
local treesitter_context = require("treesitter-context")

local function init()
    -------------------------------------------- Treesitter

    -- treesitter.nvim setup
    -- See: https://github.com/nvim-treesitter/nvim-treesitter
    ---@diagnostic disable-next-line: missing-fields
    treesitter.setup({
        -- Installed via nix
        sync_install = false,
        auto_install = false,

        -- enable hightlights
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false,
            -- additional_vim_regex_highlighting = { "markdown" },
        },

        -- enable indentation support
        indent = { enable = true, disable = { "python" } },

        -- enable commentstring plugin support for context aware commentstring
        -- context_commentstring = { enable = true, enable_autocmd = false },

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
            highlight_current_scope = { enable = false }, -- context handles this better, too distracting
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
            },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<leader>er", -- add to 'edit' prefix
                },
            },
            -- navigation = { TODO: what dis?
            --     enable = true,
            --     -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            --     keymaps = {
            --         goto_definition = "gnd",
            --         list_definitions = "gnD",
            --         list_definitions_toc = "gO",
            --         goto_next_usage = "<a-*>",
            --         goto_previous_usage = "<a-#>",
            --     },
            -- },
        },
    })
    -- TS fold support FIXME
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    -------------------------------------------- TS Context setup
    treesitter_context.setup({
        max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        multiline_threshold = 5, -- Maximum number of lines to show for a single context
        zindex = 20, -- The Z-index of the context window
    })

end

return { init = init }
