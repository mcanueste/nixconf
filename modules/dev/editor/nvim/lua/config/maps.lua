local whichkey = require("which-key")
local utils = require("config.utils")
local move = require("mini.move")

local function init()
    -------------------------------------------- Basic
    -- mini.move for moving current line or visual selection
    -- See: https://github.com/echasnovski/mini.move
    move.setup()

    vim.keymap.set({ "i" }, "<C-s>", "<C-o>:w<cr>", { noremap = true, desc = "Save file" })
    vim.keymap.set({ "n" }, "<C-s>", ":w<cr>", { noremap = true, desc = "Save file" })

    -- Clear search with ESC
    vim.keymap.set({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { noremap = true, desc = "Clear search" })

    -- Move to the beginning or end of line with H and L
    vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, desc = "Move beginning of line" })
    vim.keymap.set("n", "L", "$", { noremap = true, desc = "Move end of line" })
    vim.keymap.set("v", "L", "g_", { noremap = true, desc = "Move end of line" })

    -- Center cursor after jumps
    vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Center cursor after jump" })
    vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Center cursor after jump" })
    vim.keymap.set("n", "n", "nzzzv", { noremap = true, desc = "Center cursor after jump" })
    vim.keymap.set("n", "N", "Nzzzv", { noremap = true, desc = "Center cursor after jump" })

    -------------------------------------------- Toggles
    whichkey.register({ t = { name = "toggle" } }, { prefix = "<leader>" })

    -- add missing conceallevel toggle
    vim.keymap.set({ "n" }, "<leader>tu", utils.toggle_conceal, { noremap = true, desc = "Toggle 'conceallevel'" })

    -- vim.keymap.set({ "n" }, "<leader>uN", function()
    --     require("notify").dismiss({ silent = true, pending = true })
    -- end, { noremap = true, desc = "Dismiss all Notifications" })

    -------------------------------------------- Buffers
    whichkey.register({ b = { name = "buffer" } }, { prefix = "<leader>" })

    -- Switch to other buffer
    vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { noremap = true, desc = "Switch to Other Buffer" })

    -------------------------------------------- File Edit
    whichkey.register({ e = { name = "edit" } }, { prefix = "<leader>" })

    -- Make file executable
    vim.keymap.set(
        "n",
        "<leader>ex",
        "<cmd>!chmod +x %<CR>",
        { silent = true, noremap = true, desc = "Make file executable" }
    )

    -- Paste without saving the selected text to register
    vim.keymap.set("v", "<leader>ep", [["_dP]], { noremap = true, desc = "Paste w/o register" })

    -- Cut word under cursor without saving to register
    vim.keymap.set("n", "<leader>ed", [[viw"_d]], { noremap = true, desc = "Delete word w/o register" })

    -- Cut selected text without saving to register
    vim.keymap.set("v", "<leader>ed", [["_d]], { noremap = true, desc = "Delete w/o register" })
end

return { init = init }
