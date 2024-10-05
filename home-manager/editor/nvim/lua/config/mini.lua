local function init()
    -- mini.bufremove for deciding which buffer to show in windows after removal of current buffer
    -- See: https://github.com/echasnovski/mini.bufremove
    require("mini.bufremove").setup()

    -- mini.move for moving current line or visual selection
    -- See: https://github.com/echasnovski/mini.move
    require("mini.move").setup()

    -- mini.surround for adding/deleting surrounding objects
    -- See: https://github.com/echasnovski/mini.surround
    require("mini.surround").setup()

    -- mini.split for splitting and joininig lists/parameters/structs
    -- See: https://github.com/echasnovski/mini.splitjoin
    require("mini.splitjoin").setup({ mappings = { toggle = "<leader>es" } })

    -- mini.basics for setting up defaults
    -- See: https://github.com/echasnovski/mini.basics
    -- Only included non-default options here.
    require("mini.basics").setup({
        options = {
            -- Extra UI features ('winblend', 'cmdheight=0', ...)
            extra_ui = true,

            -- Presets for window borders ('single', 'double', ...)
            win_borders = "bold",
        },

        -- Mappings. Set to `false` to disable.
        mappings = {
            -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
            -- Supply empty string to not create these mappings.
            option_toggle_prefix = "<leader>t",

            -- Window navigation with <C-hjkl>, resize with <C-arrow>
            windows = true,
        },
    })
    -- delete mini.basics binding for sys clipboard yank and paste (using global clipboard)
    vim.keymap.del({ "n", "x" }, "gy")
    vim.keymap.del({ "n", "x" }, "gp")

    -- mini.ai for additional text objects, works better than ts-context
    -- See: https://github.com/echasnovski/mini.ai
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            o = ai.gen_spec.treesitter({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
    })

    -- mini.indent for fast indentation guide with text objects
    -- See: https://github.com/echasnovski/mini.indentscope
    require("mini.indentscope").setup({ symbol = "│" })

    -- mini.bracketed for moving forward/backward with brackets
    -- See: https://github.com/echasnovski/mini.bracketed
    require("mini.bracketed").setup({
        buffer = { suffix = "b" },
        comment = { suffix = "c" },
        conflict = { suffix = "x" },
        diagnostic = { suffix = "d" },
        jump = { suffix = "j" },
        indent = { suffix = "" }, -- using indentscope instead
        location = { suffix = "" }, -- using trouble instead
        quickfix = { suffix = "" }, -- using trouble instead
        file = { suffix = "" }, -- not using
        oldfile = { suffix = "" }, -- not using
        treesitter = { suffix = "" }, -- not using
        undo = { suffix = "" }, -- not using
        window = { suffix = "" }, -- not using
        yank = { suffix = "" }, -- not using
    })

    -- mini.comment for commenting strings
    -- See: https://github.com/echasnovski/mini.comment
    require("mini.comment").setup({
        options = {
            custom_commentstring = function()
                return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
            end,
        },
    })

    -- mini.hipatterns for highlighting based on regex
    -- See: https://github.com/echasnovski/mini.hipatterns
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })

    local trailspace = require("mini.trailspace")
    trailspace.setup()
    vim.keymap.set({ "n" }, "<leader>ew", function()
        trailspace.trim()
        trailspace.trim_last_lines()
    end, { noremap = true, desc = "Trim" })
end

return { init = init }
