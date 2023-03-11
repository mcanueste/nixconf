local utils = require("config.utils")

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

------------------------- Movements
-- Move only sideways in command mode. 
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

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

------------------------- Aux
-- Paste/Delete selected text without changing the register
map("v", "<leader>p", [["_dP]], { desc = "Paste without saving to register" })
map("v", "<leader>d", [["_d]], { desc = "Delete without saving to register" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- We use trouble.nvim instead
-- map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
-- map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

------------------------- Search
-- Search inside visually highlighted text
map("v", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("v", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("v", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Search & Replace word under cursor
-- map("n", "gwr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & Replace word under cursor" })

-- map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

------------------------- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
map("n", "<leader>bs", "<cmd>w<cr><esc>", { desc = "Save buffer" })
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })


------------------------- Windows
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

map("n", "<C-A-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-A-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

------------------------- Tabs
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })

------------------------- Lists
map("n", "<leader>ll", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>lq", "<cmd>copen<cr>", { desc = "Quickfix List" })

------------------------- Open maps
map("n", "<leader>oL", "<cmd>:Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<leader>ot", function()
  utils.float_term(nil, { cwd = utils.get_root() })
end, { desc = "Terminal (root dir)" })
map("n", "<leader>oT", function()
  utils.float_term()
end, { desc = "Terminal (cwd)" })
map("t", "<esc><esc>", "<c-\\><c-n>", {desc = "Enter Normal Mode"})

map("n", "<leader>gg", function() utils.float_term({ "lazygit" }, { cwd = utils.get_root() }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() utils.float_term({ "lazygit" }) end, { desc = "Lazygit (cwd)" })

------------------------- Toggles
map("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle Spelling" })
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", "<cmd>set relativenumber!<cr>", { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", utils.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() utils.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- Add undo break-points ??
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", ";", ";<c-g>u")
