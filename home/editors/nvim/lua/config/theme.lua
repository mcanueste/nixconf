local webdevicons = require("nvim-web-devicons")
local hipatterns = require("mini.hipatterns")
local indent = require("mini.indentscope")
local catppuccin = require("catppuccin")
local lualine = require("lualine")

local function init()
    catppuccin.setup({
        flavour = "mocha",
        integrations = {
            mini = true,
            harpoon = true,
            gitsigns = true,
            markdown = false, -- TODO disable if creates issues
            which_key = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            lsp_trouble = true,
            native_lsp = {
                enabled = true,
            },
        },
        term_colors = true,
        transparent_background = true,
    })
    vim.cmd.colorscheme("catppuccin")

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "catppuccin",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
        },
        extensions = { "fzf", "quickfix", "neo-tree" },
    })

    indent.setup({
        symbol = "│",
        mappings = {
            -- Textobjects
            object_scope = "ii",
            object_scope_with_border = "ai",
            -- Motions (jump to respective border line; if not present - body line)
            goto_top = "[i",
            goto_bottom = "]i",
        },
    })

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

    webdevicons.setup()
end

return { init = init }
