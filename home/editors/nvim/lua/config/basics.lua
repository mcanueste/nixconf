local bracketed = require("mini.bracketed")
local bufremove = require("mini.bufremove")
local basics = require("mini.basics")
local utils = require("config.utils")
local move = require("mini.move")

local function augroup(name)
    return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

local function init()
    basics.setup({
        options = {
            basic = true,
            extra_ui = true,
            win_borders = "bold",
        },
        mappings = {
            basic = true,
            option_toggle_prefix = "<leader>u",
            windows = false, -- we use vim-tmux-navigator anyway
            move_with_alt = false, -- TODO: conflicts with tmux maps
        },
        autocommands = {
            basic = true,
            relnum_in_visual_mode = true,
        },
        silent = false, -- Whether to disable showing non-error feedback
    })
    vim.keymap.del({ "n", "x" }, "gy") -- delete mini.basics binding
    vim.keymap.del({ "n", "x" }, "gp") -- delete mini.basics binding

    move.setup({
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "<C-S-h>",
            right = "<C-S-l>",
            down = "<C-S-j>",
            up = "<C-S-k>",

            -- Move current line in Normal mode
            line_left = "<C-S-h>",
            line_right = "<C-S-l>",
            line_down = "<C-S-j>",
            line_up = "<C-S-k>",
        },
    })

    bracketed.setup({
        buffer = { suffix = "b", options = {} },
        comment = { suffix = "c", options = {} },
        conflict = { suffix = "x", options = {} },
        diagnostic = { suffix = "d", options = {} },
        location = { suffix = "l", options = {} },
        indent = { suffix = "", options = {} },
        file = { suffix = "", options = {} },
        jump = { suffix = "", options = {} },
        oldfile = { suffix = "", options = {} },
        quickfix = { suffix = "", options = {} },
        treesitter = { suffix = "", options = {} },
        undo = { suffix = "", options = {} },
        window = { suffix = "", options = {} },
        yank = { suffix = "", options = {} },
    })

    bufremove.setup()

    -------------------------------------------- Options
    vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
    vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
    vim.opt.inccommand = "nosplit" -- preview incremental substitute
    vim.opt.autowrite = true -- Enable auto write

    vim.opt.grepformat = "%f:%l:%c:%m" -- Formatting of :grep
    vim.opt.grepprg = "rg --vimgrep" -- :grep command to use

    vim.opt.expandtab = true -- Use spaces instead of tabs
    vim.opt.shiftround = true -- Round indent
    vim.opt.shiftwidth = 4 -- Size of an indent
    vim.opt.tabstop = 4 -- Number of spaces tabs count for
    vim.opt.relativenumber = true -- Relative line numbers

    vim.opt.sidescrolloff = 8 -- Columns of context
    vim.opt.conceallevel = 0 -- Hide * markup for bold and italic (if incremented)

    vim.opt.list = false -- hide listchars

    vim.opt.spell = false
    vim.opt.spelllang = { "en" }

    vim.opt.timeout = true
    vim.opt.timeoutlen = 300

    vim.opt.undolevels = 10000 -- keep longer undo history
    vim.opt.swapfile = false -- don't use swapfiles

    vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

    -- Fix markdown indentation settings
    vim.g.markdown_recommended_style = 0

    -- Editing
    vim.opt.isfname:append("@-@") -- Filename for gf and other file commands

    vim.opt.formatoptions = "jql1tcron"

    -------------------------------------------- Autocommands
    -- Check if we need to reload the file when it changed
    vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
        group = augroup("checktime"),
        command = "checktime",
    })

    -- resize splits if window got resized
    vim.api.nvim_create_autocmd({ "VimResized" }, {
        group = augroup("resize_splits"),
        callback = function()
            vim.cmd("tabdo wincmd =")
        end,
    })

    -- go to last loc when opening a buffer
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = augroup("last_loc"),
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

    -- close some filetypes with <q>
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("close_with_q"),
        pattern = {
            "PlenaryTestPopup",
            "help",
            "lspinfo",
            "man",
            "startuptime",
            "tsplayground",
            "query", -- :InspectTree
            "harpoon",
            "spectre_panel",
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end,
    })

    -- wrap and check for spell in text filetypes
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("wrap_spell"),
        pattern = { "gitcommit", "markdown" },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end,
    })

    -------------------------------------------- Keymaps
    vim.keymap.set({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { noremap = true, desc = "Clear search" })

    vim.keymap.set({ "n" }, "<leader>uu", function() utils.toggle_conceal() end, { noremap = true, desc = "Toggle 'conceallevel'" })

    -- TODO maybe remap these keys to something else?
    vim.keymap.set(
        "n",
        "<C-Left>",
        '"<Cmd>vertical resize -" . v:count5 . "<CR>"',
        { expr = true, replace_keycodes = false, desc = "Decrease window width" }
    )
    vim.keymap.set(
        "n",
        "<C-Down>",
        '"<Cmd>resize -"          . v:count5 . "<CR>"',
        { expr = true, replace_keycodes = false, desc = "Decrease window height" }
    )
    vim.keymap.set(
        "n",
        "<C-Up>",
        '"<Cmd>resize +"          . v:count5 . "<CR>"',
        { expr = true, replace_keycodes = false, desc = "Increase window height" }
    )
    vim.keymap.set(
        "n",
        "<C-Right>",
        '"<Cmd>vertical resize +" . v:count5 . "<CR>"',
        { expr = true, replace_keycodes = false, desc = "Increase window width" }
    )

    vim.keymap.set({ "i", "v", "n", "s" }, "<C-q><C-q>", "<cmd>qa<cr>", { noremap = true, desc = "Quit all" })

    vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, desc = "Move beginning of line" })
    vim.keymap.set("n", "L", "$", { noremap = true, desc = "Move end of line" })
    vim.keymap.set("v", "L", "g_", { noremap = true, desc = "Move end of line" })

    vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next Tab" })
    vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous Tab" })
    vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New Tab" })
    vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { noremap = true, desc = "Last Tab" })
    vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { noremap = true, desc = "First Tab" })

    vim.keymap.set("v", "gp", [["_dP]], { noremap = true, desc = "Paste w/o register" })
    vim.keymap.set("v", "gx", [["_d]], { noremap = true, desc = "Delete w/oregister" })
    vim.keymap.set(
        "n",
        "gr",
        [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        { noremap = true, desc = "Search & Replace word under cursor" }
    )

    vim.keymap.set("n", "<leader>gg", "<cmd>e #<cr>", { noremap = true, desc = "Switch to Other Buffer" })
    vim.keymap.set(
        "n",
        "<leader>gx",
        "<cmd>!chmod +x %<CR>",
        { silent = true, noremap = true, desc = "Make file executable" }
    )
end

return { init = init }
