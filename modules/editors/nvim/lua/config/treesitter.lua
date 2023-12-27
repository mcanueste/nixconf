local treesitter = require("nvim-treesitter.configs")
local bracketed = require("mini.bracketed")
local indent = require("mini.indentscope")
local whichkey = require("which-key")
local miniai = require("mini.ai")
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

    -------------------------------------------- Additional TS objects and keymaps

    -- mini.ai for additional text objects, works better than ts-context
    -- See: https://github.com/echasnovski/mini.ai
    miniai.setup({
        n_lines = 500,
        custom_textobjects = {
            o = miniai.gen_spec.treesitter({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = miniai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
    })
    local objects = {
        [" "] = "Whitespace",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        c = "Class",
        f = "Function",
        o = "Block-Conditional-Loop",
        q = "Quote",
    }
    whichkey.register({ mode = { "o", "x" }, i = objects, a = objects })

    -- mini.indent for fast indentation guide with text objects
    -- See: https://github.com/echasnovski/mini.indentscope
    indent.setup({
        symbol = "│",
        mappings = {
            -- Textobjects
            object_scope = "ii",
            object_scope_with_border = "ai",
            -- Motions (jump to respective border line; if not present - body line)
            goto_top = "", -- "[i", disabled
            goto_bottom = "", -- "]i", disabled
        },
    })

    -- mini.bracketed for moving forward/backward with brackets
    -- See: https://github.com/echasnovski/mini.bracketed
    bracketed.setup({
        buffer = { suffix = "b", options = {} },
        comment = { suffix = "c", options = {} },
        conflict = { suffix = "x", options = {} },
        diagnostic = { suffix = "d", options = {} },
        file = { suffix = "", options = {} }, -- not using
        indent = { suffix = "i", options = {} },
        jump = { suffix = "j", options = {} },
        location = { suffix = "", options = {} }, -- using trouble
        oldfile = { suffix = "", options = {} }, -- not using
        quickfix = { suffix = "", options = {} }, -- using trouble
        treesitter = { suffix = "", options = {} }, -- not using
        undo = { suffix = "", options = {} }, -- not using
        window = { suffix = "", options = {} }, -- not using
        yank = { suffix = "", options = {} }, -- not using
    })
end

return { init = init }
