-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Backups
opt.backup = false -- Don't store backup while overwriting the file
opt.writebackup = false -- Don't store backup while overwriting the file

-- Appearance
opt.breakindent = true -- Indent wrapped lines to match line start
opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
opt.rnu = true -- Use relative numbers
opt.winblend = 10 -- Make floating windows slightly transparent
opt.scrolloff = 8

-- Editing
opt.incsearch = true -- Show search results while typing
opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
opt.virtualedit = "block" -- Allow going past the end of line in visual block mode
opt.formatoptions = "jcroqlnt1"
opt.isfname:append("@-@") -- Filename for gf and other file commands
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd([[syntax enable]])
end
