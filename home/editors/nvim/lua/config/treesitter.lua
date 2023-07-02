local treesitter = require("nvim-treesitter.configs")
local whichkey = require("which-key")
local miniai = require("mini.ai")

local function init()
    treesitter.setup({
        highlight = { enable = true, disable = { "comment" } },
        indent = { enable = true, disable = { "python" } },
        context_commentstring = { enable = true, enable_autocmd = false },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>", -- TODO Might change later
                node_incremental = "<C-space>",
                scope_incremental = "<nop>",
                node_decremental = "<bs>",
            },
        },
    })

    miniai.setup({ -- TODO setup text objects and keybindings
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
        o = "Block-Conditional-loop",
        q = "Quote",
    }
    whichkey.register({ mode = { "o", "x" }, i = objects, a = objects })
end

return { init = init }
