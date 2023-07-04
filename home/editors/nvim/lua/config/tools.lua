local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local comment = require("mini.comment")
local pairs = require("mini.pairs")
local files = require("mini.files")
local harpoon = require("harpoon")
local fterm = require("FTerm")

local function init()
    splitjoin.setup()
    surround.setup()
    comment.setup()
    pairs.setup()
    files.setup()
    vim.keymap.set("n", "<leader>oe", function()
        files.open()
    end, { noremap = true, desc = "Files" })

    -------------------------------------------- Floating term
    fterm.setup({
        ---Filetype of the terminal buffer
        ft = "FTerm",
        border = "double",
        auto_close = true,
        dimensions = {
            height = 0.9, -- Height of the terminal window
            width = 0.9, -- Width of the terminal window
            x = 0.5, -- X axis of the terminal window
            y = 0.5, -- Y axis of the terminal window
        },
    })
    local lazygit = fterm:new({
        ft = "fterm_lazygit",
        cmd = "lazygit",
        dimensions = {
            height = 0.9,
            width = 0.9,
        },
    })
    local lazydocker = fterm:new({
        ft = "fterm_lazydocker",
        cmd = "lazydocker",
        dimensions = {
            height = 0.9,
            width = 0.9,
        },
    })
    vim.keymap.set("n", "<leader>ot", "<CMD>lua require('FTerm').toggle()<CR>", { noremap = true, desc = "Terminal" })
    vim.keymap.set("n", "<leader>og", function()
        lazygit:toggle()
    end, { noremap = true, desc = "Lazygit" })
    vim.keymap.set("n", "<leader>od", function()
        lazydocker:toggle()
    end, { noremap = true, desc = "Lazydocker" })
    -- vim.keymap.set('n', '<leader>ok', '<CMD>FloatermNew --autoclose=2 --height=0.9 --width=0.9 k9s<CR>', { noremap = true, desc = "K9s" })
    -- vim.keymap.set('n', '<leader>ob', '<CMD>FloatermNew --autoclose=2 --height=0.9 --width=0.9 btm<CR>', { noremap = true, desc = "Bottom" })
    -- vim.keymap.set('n', '<leader>on', '<CMD>FloatermNew --autoclose=2 --height=0.75 --width=0.75 nnn -Hde<CR>', { noremap = true, desc = "NNN" })

    -------------------------------------------- Floating term
    harpoon.setup({
        global_settings = {
            -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_toggle = true,
            -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
            tmux_autoclose_windows = false,
            -- filetypes that you want to prevent from adding to the harpoon list menu.
            excluded_filetypes = { "harpoon" },
        },
    })
    vim.cmd([[ autocmd Filetype harpoon setlocal cursorline ]])
    vim.cmd([[ hi HarpoonWindow guibg=#1E1E2E ]])
    vim.cmd([[ hi HarpoonBorder guibg=#1E1E2E guifg=#CDD6F4 ]])
    vim.keymap.set("n", "<leader>hm", function()
        require("harpoon.mark").add_file()
    end, { noremap = true, desc = "Mark file" })
    vim.keymap.set("n", "<leader>hh", function()
        require("harpoon.ui").toggle_quick_menu()
    end, { noremap = true, desc = "Menu" })
    vim.keymap.set("n", "<leader>hn", function()
        require("harpoon.ui").nav_next()
    end, { noremap = true, desc = "Open next" })
    vim.keymap.set("n", "<leader>hp", function()
        require("harpoon.ui").nav_prev()
    end, { noremap = true, desc = "Open prev" })
    vim.keymap.set("n", "<leader>hf", function()
        require("harpoon.ui").nav_file(1)
    end, { noremap = true, desc = "Open f" })
    vim.keymap.set("n", "<leader>hd", function()
        require("harpoon.ui").nav_file(2)
    end, { noremap = true, desc = "Open d" })
    vim.keymap.set("n", "<leader>hs", function()
        require("harpoon.ui").nav_file(3)
    end, { noremap = true, desc = "Open s" })
    vim.keymap.set("n", "<leader>ha", function()
        require("harpoon.ui").nav_file(4)
    end, { noremap = true, desc = "Open a" })
end

return { init = init }
