local bufremove = require("mini.bufremove")
local basics = require("mini.basics")

local function augroup(name)
    return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

local function init()
    -- mini.basics for setting up defaults
    -- See: https://github.com/echasnovski/mini.basics
    basics.setup({
        -- Whether to disable showing non-error feedback
        silent = false,

        options = {
            -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
            -- See: https://github.com/echasnovski/mini.basics/blob/c31a4725710db9733e8a8edb420f51fd617d72a3/lua/mini/basics.lua#L436
            basic = true,

            -- Extra UI features ('winblend', 'cmdheight=0', ...)
            -- NOTE: Not using. Messes up floating windows background
            -- See: https://github.com/echasnovski/mini.basics/blob/c31a4725710db9733e8a8edb420f51fd617d72a3/lua/mini/basics.lua#L489
            extra_ui = false,

            -- Consistent bold single line window borders
            -- See: https://github.com/echasnovski/mini.basics/blob/c31a4725710db9733e8a8edb420f51fd617d72a3/lua/mini/basics.lua#L502
            win_borders = "bold",
        },
        mappings = {
            -- Basic mappings (better 'jk', save with Ctrl+S, ...)
            -- See: https://github.com/echasnovski/mini.basics/blob/c31a4725710db9733e8a8edb420f51fd617d72a3/lua/mini/basics.lua#L541C32-L541C32
            basic = true,

            -- Prefix for mappings common options toggles ('wrap', 'spell', ...).
            option_toggle_prefix = "<leader>t",

            -- Window navigation with <C-hjkl>, resize with <C-arrow>
            -- Using vim-tmux-navigator as well
            windows = true,

            -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
            move_with_alt = true,
        },
        autocommands = {
            -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
            -- See: https://github.com/echasnovski/mini.basics/blob/c31a4725710db9733e8a8edb420f51fd617d72a3/lua/mini/basics.lua#L716
            basic = true,

            -- Set 'relativenumber' only in linewise and blockwise Visual mode
            -- Disable to have relative numbers all the time
            relnum_in_visual_mode = false,
        },
    })

    -- delete mini.basics binding for sys clipboard yank and paste (using global clipboard)
    vim.keymap.del({ "n", "x" }, "gy")
    vim.keymap.del({ "n", "x" }, "gp")

    -- mini.bufremove for deciding which buffer to show in windows after removal of current buffer
    -- See: https://github.com/echasnovski/mini.bufremove
    bufremove.setup()

    -- TODO: remove unused builtin nvim plugins. see nvchad configs for more details

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

    vim.opt.spell = false -- TODO: enable with AI support?
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

    vim.opt.foldenable = false -- disable folds at startup

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
            "help",
            "lspinfo",
            "man",
            "harpoon",
            "FTerm"
            -- "spectre_panel",
            -- "PlenaryTestPopup",
            -- TODO: add floating term and other tools here
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
end

return { init = init }
