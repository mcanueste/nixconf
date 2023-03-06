-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function delmap(mode, old_lhs)
  vim.keymap.del(mode, old_lhs)
end

-- Delete default LazyVim mappings
delmap("n", "<leader>l")
delmap("n", "<leader>ww")
delmap("n", "<leader>wd")
delmap("n", "<leader>w-")
delmap("n", "<leader>w|")
delmap("n", "<leader>-")
delmap("n", "<leader>|")
delmap("n", "<leader>ft")
delmap("n", "<leader>fT")
delmap("n", "<C-Up>")
delmap("n", "<C-Down>")
delmap("n", "<C-Left>")
delmap("n", "<C-Right>")
delmap("n", "<leader>`")
delmap("n", "<leader>fn")
delmap("n", "<S-h>")
delmap("n", "<S-l>")
delmap("n", "<leader><tab><tab>")
delmap("n", "<leader><tab>]")
delmap("n", "<leader><tab>d")
delmap("n", "<leader><tab>[")
delmap("n", "<leader>xl")
delmap("n", "<leader>xq")

-- Open lazy
map("n", "<leader>ol", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- floating terminal
map("n", "<leader>ot", function()
  Util.float_term(nil, { cwd = Util.get_root() })
end, { desc = "Terminal (root dir)" })
map("n", "<leader>oT", function()
  Util.float_term()
end, { desc = "Terminal (cwd)" })

-- Window maps
map("n", "<leader>ws", "<C-w>s", { desc = "Split window" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>wq", "<C-w>q", { desc = "Quit a window" })
map("n", "<leader>wx", "<C-w>x", { desc = "Swap current with next" })
map("n", "<leader>wT", "<C-w>T", { desc = "Break out into new tab" })

map("n", "<leader>ww", "<C-W>w", { desc = "Switch windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to down window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to up window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>w+", "<C-w>+", { desc = "Increase height" })
map("n", "<leader>w-", "<C-w>-", { desc = "Decrease height" })
map("n", "<leader>w>", "<C-w>>", { desc = "Increase width" })
map("n", "<leader>w<", "<C-w><", { desc = "Decrease width" })
map("n", "<leader>w_", "<C-w>_", { desc = "Max out the height" })
map("n", "<leader>w|", "<C-w>|", { desc = "Max out the width" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equally high and wide" })

-- Resize window using <Ctrl-Alt-[hjkl]>
map("n", "<C-A-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-A-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer mappings
map("n", "<leader>bs", "<cmd>w<cr><esc>", { desc = "Save buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Tab mappings
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- Quickfix
map("n", "<leader>ll", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>lq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Paste/Delete selected text without changing the register
map("v", "gp", [["_dP]], { desc = "Paste without saving to register" })
map("v", "gd", [["_d]], { desc = "Delete without saving to register" })

-- Add empty lines before and after cursor line
map("n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" })
map("n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" })

-- Search & Replace word under cursor
map("n", "gwr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & Replace word under cursor" })

-- Search inside visually highlighted text
map("v", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("v", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("v", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Correct latest misspelled word by taking first suggestion.
-- Use `<C-g>u` in Insert mode to mark this as separate undoable action.
-- Source: https://stackoverflow.com/a/16481737
map("n", "<C-Z>", "[s1z=", { desc = "Correct latest misspelled word" })
map("i", "<C-Z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Correct latest misspelled word" })

-- Move only sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
map("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
map("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })

-- Don't `noremap` in insert mode to have these keybindings behave exactly
-- like arrows (crucial inside TelescopePrompt)
map("i", "<M-h>", "<Left>", { noremap = false, desc = "Left" })
map("i", "<M-j>", "<Down>", { noremap = false, desc = "Down" })
map("i", "<M-k>", "<Up>", { noremap = false, desc = "Up" })
map("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
map("t", "<M-h>", "<Left>", { desc = "Left" })

map("t", "<M-j>", "<Down>", { desc = "Down" })
map("t", "<M-k>", "<Up>", { desc = "Up" })
map("t", "<M-l>", "<Right>", { desc = "Right" })
map("t", "<M-l>", "<Right>", { desc = "Right" })
