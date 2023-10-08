local gitsigns = require("gitsigns")

local function init()
    gitsigns.setup({
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        on_attach = function(bufnr)
            require("which-key").register({ v = { name = "vcs" } }, { prefix = "<leader>" })
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc, opts)
                opts = opts or {}
                opts.buffer = bufnr
                opts.desc = desc
                opts.noremap = true
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    return "]h"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, "Next hunk", { expr = true })

            map("n", "[h", function()
                if vim.wo.diff then
                    return "[h"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, "Previous hunk", { expr = true })

            -- Actions
            map("n", "<leader>vb", function()
                gs.blame_line({ full = true })
            end, "Blame line")
            map("n", "<leader>vB", gs.toggle_current_line_blame, "Toggle line blame")
            map("n", "<leader>vs", gs.stage_hunk, "Stage hunk")
            map("v", "<leader>vs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage hunk")
            map("n", "<leader>vS", gs.stage_buffer, "Stage buffer")
            map("n", "<leader>vu", gs.undo_stage_hunk, "Undo stage hunk")
            map("v", "<leader>vu", gs.undo_stage_hunk, "Undo stage hunk")
            map("n", "<leader>vd", gs.diffthis, "Show diff")
            map("n", "<leader>vD", function()
                gs.diffthis("~")
            end, "Show diff ~")

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")

            -- Telescope
            map("n", "<leader>vc", "<cmd>Telescope git_commits<CR>", { noremap = true, desc = "Commits" })
            map("n", "<leader>vC", "<cmd>Telescope git_bcommits<CR>", { noremap = true, desc = "Buffer Commits" })
            map("n", "<leader>vt", "<cmd>Telescope git_stash<CR>", { noremap = true, desc = "Stash" })
            map("n", "<leader>vr", "<cmd>Telescope git_branches<CR>", { noremap = true, desc = "Branches" })
        end,
    })
end

return { init = init }
