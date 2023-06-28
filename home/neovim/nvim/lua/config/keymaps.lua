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

-- Paste/Delete selected text without changing the register
map("v", "gp", [["_dP]], { desc = "Paste without saving to register" })
-- map("v", "gx", [["_d]], { desc = "Delete without saving to register" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Search inside visually highlighted text
map("v", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search & Replace word under cursor
map(
  "n",
  "<leader>gR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search & Replace word under cursor" }
)

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("v", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("v", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
map("n", "<leader>bs", "<cmd>w<cr><esc>", { desc = "Save buffer" })
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

------------------------ Move
map("n", "H", "^", { desc = "Move beginning of line" })
map("n", "L", "$", { desc = "Move end of line" })
map("v", "H", "^", { desc = "Move beginning of line" })
map("v", "L", "g_", { desc = "Move end of line" })

-- Move Lines
-- map("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- map("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

------------------------- Windows
-- map("n", "<C-K>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- map("n", "<C-J>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- map("n", "<C-H>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- map("n", "<C-L>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

------------------------- Tabs
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })

------------------------- Lists
-- We use trouble.nvim instead
-- map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
-- map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
-- map("n", "<leader>ll", "<cmd>lopen<cr>", { desc = "Location List" })
-- map("n", "<leader>lq", "<cmd>copen<cr>", { desc = "Quickfix List" })

------------------------- Open
map("n", "<leader>oL", "<cmd>:Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>ot", function()
  utils.float_term("fish", { cwd = utils.get_root() })
end, { desc = "Terminal (root dir)" })
map("n", "<leader>oT", function()
  utils.float_term("fish")
end, { desc = "Terminal (cwd)" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("n", "<leader>og", function()
  utils.float_term({ "lazygit" }, { cwd = utils.get_root() })
end, { desc = "Lazygit (root dir)" })
map("n", "<leader>oG", function()
  utils.float_term({ "lazygit" })
end, { desc = "Lazygit (cwd)" })

------------------------- Toggles
map("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle Spelling" })
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", "<cmd>set relativenumber!<cr>", { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", utils.toggle_diagnostics, { desc = "Toggle Diagnostics" })
-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- map("n", "<leader>uc", function()
--   utils.toggle("conceallevel", false, { 0, conceallevel })
-- end, { desc = "Toggle Conceal" })
