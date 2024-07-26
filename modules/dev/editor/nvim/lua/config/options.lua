local function init()
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
    vim.opt.scrolloff = 10 -- Rows of context
    vim.opt.conceallevel = 1 -- Hide * markup for bold and italic (if incremented)

    vim.opt.list = false -- hide listchars

    vim.opt.spell = false -- disable by default
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
end

return { init = init }
