local function init()
    -- Setup web-devicons
    -- See: https://github.com/nvim-tree/nvim-web-devicons
    require("nvim-web-devicons").setup()

    -- Setup lualine status line
    -- See: https://github.com/nvim-lualine/lualine.nvim
    require("lualine").setup({
        options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
        },
        extensions = {
            "fzf",
            "man",
            "nvim-dap-ui",
            "oil",
            -- "overseer",
            "quickfix",
            -- "symbols-outline",
            -- "toggleterm",
            "trouble",
        },
    })
end

return { init = init }
