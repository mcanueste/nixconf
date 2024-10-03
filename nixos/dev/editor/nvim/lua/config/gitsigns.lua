local function init()
    require("gitsigns").setup({
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        attach_to_untracked = true,
        on_attach = function(bufnr)
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
            end, "Next Git Hunk", { expr = true })

            map("n", "[h", function()
                if vim.wo.diff then
                    return "[h"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, "Previous Git Hunk", { expr = true })

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

            -- Toggles
            map("n", "<leader>gts", "<cmd>Gitsigns toggle_signs<cr>", "Toggle Signs")
            map("n", "<leader>gtn", "<cmd>Gitsigns toggle_numhl<cr>", "Toggle Num HL")
            map("n", "<leader>gtl", "<cmd>Gitsigns toggle_linehl<cr>", "Toggle Line HL")
            map("n", "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<cr>", "Toggle Word HL")
            map("n", "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle Line Blame")
            map("n", "<leader>gtd", "<cmd>Gitsigns toggle_deleted", "Toggle Deleted")

            -- Actions
            map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
            map("v", "<leader>gs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage Hunk")
            map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")

            map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
            map("v", "<leader>gr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset Hunk")
            map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")

            map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")

            map("n", "<leader>gb", function()
                gs.blame_line({ full = true })
            end, "Blame Line")

            map("n", "<leader>gd", gs.diffthis, "Diff This")
            map("n", "<leader>gD", function()
                gs.diffthis("~")
            end, "Diff This ~")
        end,
    })
end

return { init = init }
