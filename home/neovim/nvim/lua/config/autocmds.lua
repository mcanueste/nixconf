-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Start terminal in insert mode
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = augroup("terminal"),
  pattern = "*",
  command = "startinsert",
})
