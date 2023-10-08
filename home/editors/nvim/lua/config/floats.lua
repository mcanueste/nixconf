local fterm = require("FTerm")

local function init()
    -------------------------------------------- Floating term
    ---@diagnostic disable-next-line: missing-fields
    fterm.setup({
        ---Filetype of the terminal buffer
        ft = "FTerm",
        -- border = "double",
        auto_close = true,
        dimensions = {
            height = 0.95, -- Height of the terminal window
            width = 0.95, -- Width of the terminal window
            x = 0.5, -- X axis of the terminal window
            y = 0.5, -- Y axis of the terminal window
        },
    })
    vim.keymap.set("n", "<leader>ot", "<CMD>lua require('FTerm').toggle()<CR>", { noremap = true, desc = "Terminal" })
    vim.keymap.set("t", "<C-o>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

    ---@diagnostic disable-next-line: missing-fields
    local lazygit = fterm:new({
        ft = "fterm_lazygit",
        cmd = "lazygit",
        ---@diagnostic disable-next-line: missing-fields
        dimensions = {
            height = 0.95,
            width = 0.95,
        },
    })
    vim.keymap.set("n", "<leader>og", function()
        lazygit:toggle()
    end, { noremap = true, desc = "Lazygit" })

    ---@diagnostic disable-next-line: missing-fields
    local lazydocker = fterm:new({
        ft = "fterm_lazydocker",
        cmd = "lazydocker",
        ---@diagnostic disable-next-line: missing-fields
        dimensions = {
            height = 0.95,
            width = 0.95,
        },
    })

    vim.keymap.set("n", "<leader>od", function()
        lazydocker:toggle()
    end, { noremap = true, desc = "Lazydocker" })

    -- vim.keymap.set('n', '<leader>ok', '<CMD>FloatermNew --autoclose=2 --height=0.9 --width=0.9 k9s<CR>', { noremap = true, desc = "K9s" })
    -- vim.keymap.set('n', '<leader>ob', '<CMD>FloatermNew --autoclose=2 --height=0.9 --width=0.9 btm<CR>', { noremap = true, desc = "Bottom" })
    -- vim.keymap.set('n', '<leader>on', '<CMD>FloatermNew --autoclose=2 --height=0.75 --width=0.75 nnn -Hde<CR>', { noremap = true, desc = "NNN" })
end

return { init = init }
