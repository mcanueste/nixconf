local webdevicons = require("nvim-web-devicons")
local hipatterns = require("mini.hipatterns")
local catppuccin = require("catppuccin")
local whichkey = require("which-key")
local lualine = require("lualine")
local notify = require("notify")
local noice = require("noice")

local function init()
    -- Setup web-devicons
    -- See: https://github.com/nvim-tree/nvim-web-devicons
    webdevicons.setup()

    -- Setup catppuccin colorscheme
    -- See: https://github.com/catppuccin/nvim
    catppuccin.setup({
        flavour = "mocha",
        term_colors = true,
        transparent_background = true,

        -- Enable integrations
        -- See: https://github.com/catppuccin/nvim#integrations
        integrations = {
            gitsigns = true,
            harpoon = true,
            markdown = true,
            mini = true,
            treesitter = true,
            treesitter_context = true,
            lsp_trouble = true,
            cmp = true,
            which_key = true,
            noice = true,
            notify = true,
            telescope = {
                enabled = true,
                -- style = "nvchad"
            },
            -- dap = {
            --     enabled = true,
            --     enable_ui = true, -- enable nvim-dap-ui
            -- },
            native_lsp = {
                enabled = true,
                virtual_text = { -- FIXME: might be too distracting
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
        },
    })
    vim.cmd.colorscheme("catppuccin")

    -- Setup lualine status line
    -- See: https://github.com/nvim-lualine/lualine.nvim
    ---@diagnostic disable-next-line: undefined-field
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

    -- mini.hipatterns for highlighting based on regex
    -- See: https://github.com/echasnovski/mini.hipatterns
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

    -- TODO: add keymaps for disabling and removing notifications?
    -- notify-nvim for notifications
    -- See: https://github.com/folke/noice.nvim
    notify.setup({
        background_colour = "#1E1E2E",
    })

    -- noice.nvim for fancy gui
    -- See: https://github.com/folke/noice.nvim
    noice.setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
    })

    -- Setup whichkey first in 'basics' and register helpers later on
    -- See: https://github.com/folke/which-key.nvim
    whichkey.setup()
end

return { init = init }
