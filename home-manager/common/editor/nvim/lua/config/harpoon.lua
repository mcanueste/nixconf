local function init()
    -- harpoon for file navigation
    -- See: https://github.com/ThePrimeagen/harpoon
    local harpoon = require("harpoon")
    harpoon:setup()

    require("harpoon").setup({
        global_settings = {
            -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_toggle = true,
            -- closes any tmux windows that harpoon creates when you close Neovim.
            tmux_autoclose_windows = false,
            -- filetypes that you want to prevent from adding to the harpoon list menu.
            excluded_filetypes = { "harpoon", "oil" },
        },
    })

    require("config.autocommands").close_with_q("harpoon", { "harpoon" })

    vim.keymap.set("n", "<leader>hh", function()
        harpoon:list():add()
    end, { noremap = true, desc = "Mark file" })
    vim.keymap.set("n", "<leader>hm", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { noremap = true, desc = "Menu" })
    vim.keymap.set("n", "<leader>hn", function()
        harpoon:list():next()
    end, { noremap = true, desc = "Open next" })
    vim.keymap.set("n", "<leader>hp", function()
        harpoon:list():prev()
    end, { noremap = true, desc = "Open prev" })
    vim.keymap.set("n", "<leader>hf", function()
        harpoon:list():select(1)
    end, { noremap = true, desc = "Open f" })
    vim.keymap.set("n", "<leader>hd", function()
        harpoon:list():select(2)
    end, { noremap = true, desc = "Open d" })
    vim.keymap.set("n", "<leader>hs", function()
        harpoon:list():select(3)
    end, { noremap = true, desc = "Open s" })
    vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():select(4)
    end, { noremap = true, desc = "Open a" })
end

return { init = init }
