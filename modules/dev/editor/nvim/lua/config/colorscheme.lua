local catppuccin = require("catppuccin")

local function init()
    -- Setup catppuccin colorscheme
    -- See: https://github.com/catppuccin/nvim
    require("catppuccin").setup({
        -- dark: mocha, light: latte
        transparent_background = true, -- disables setting the background color.
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = true, -- dims the background color of inactive window
        },

        -- Enable integrations
        -- See: https://github.com/catppuccin/nvim#integrations
        integrations = {
            gitsigns = true,
            harpoon = true,
            markdown = true,
            mini = {
                enabled = true,
                indentscope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
            },
            cmp = true,
            dap = true,
            dap_ui = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
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
            treesitter = true,
            treesitter_context = true,
            telescope = {
                enabled = true,
                style = "nvchad",
            },
            lsp_trouble = true,
            which_key = true,
        },
    })

    vim.cmd.colorscheme("catppuccin")
end

return { init = init }
