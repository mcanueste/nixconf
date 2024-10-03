local telescope = require("telescope.builtin")

local M = {}

function M.toggle_conceal()
    -- Toggle conceal
    local winnr = vim.api.nvim_get_current_win()
    local conceallevel = vim.api.nvim_win_get_option(winnr, "conceallevel")
    local newconceallevel = math.fmod(conceallevel + 1, 4)
    vim.opt.conceallevel = newconceallevel
end

function M.get_git_root()
    local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
    if vim.v.shell_error == 0 then
        return root
    end
    return nil
end

function M.telescope_find_files()
    local root = M.get_git_root()
    if root == nil then
        telescope.find_files()
    else
        telescope.find_files({ cwd = root })
    end
end

function M.telescope_live_grep()
    local root = M.get_git_root()
    if root == nil then
        telescope.live_grep()
    else
        telescope.live_grep({ cwd = root })
    end
end

function M.telescope_grep_string()
    local root = M.get_git_root()
    if root == nil then
        telescope.grep_string()
    else
        telescope.grep_string({ cwd = root })
    end
end

return M
