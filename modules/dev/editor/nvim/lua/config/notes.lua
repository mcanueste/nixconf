local obsidian = require("obsidian")
local markview = require("markview")

local date_verbose = function()
    return os.date("%A, %B %d, %Y")
end

local daily = function()
    return os.date("logs/%Y/%m/%Y-%m-%d")
end

local daily_previous = function()
    return os.date("logs/%Y/%m/%Y-%m-%d", os.time() - 24 * 60 * 60)
end

local daily_next = function()
    return os.date("logs/%Y/%m/%Y-%m-%d", os.time() + 24 * 60 * 60)
end

local weekly = function()
    -- Week starts from Monday
    return os.date("logs/%Y/Weekly/%yW%V", os.time() - 24 * 60 * 60)
end

local function init()
    markview.setup({
        modes = { "n", "i", "no", "c" },
        hybrid_modes = { "i" },

        -- This is nice to have
        callbacks = {
            on_enable = function(_, win)
                vim.wo[win].conceallevel = 2
                vim.wo[win].concealcursor = "nc"
            end,
        },
    })
    vim.cmd("Markview enableAll")
    vim.keymap.set("n", "<leader>nV", "<cmd>Markview toggle<cr>", { noremap = true, desc = "Toggle Renderer" })

    local home = vim.fn.expand("$HOME")
    local vault_path = home .. "/Projects/personal/notes"

    ---@diagnostic disable-next-line: missing-fields
    local client = obsidian.setup({
        dir = vault_path,
        log_level = vim.log.levels.INFO,
        open_notes_in = "vsplit",
        new_notes_location = "current_dir",
        ui = { enable = false }, -- use markview for rendering

        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },

        templates = {
            subdir = "_templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {
                date_verbose = date_verbose,
                daily = daily,
                daily_previous = daily_previous,
                daily_next = daily_next,
                weekly = weekly,
            },
        },

        attachments = { img_folder = "_attachments" },

        daily_notes = {
            folder = "logs",
            date_format = "%Y/%m/%Y-%m-%d",
            template = "daily.md",
        },

        note_id_func = function(title)
            -- If title is not given, use ISO timestamp, otherwise use as is
            if title == nil then
                return tostring(os.date("%y%m%d%H%M%S"))
            end
            return title
        end,

        disable_frontmatter = true,
        note_frontmatter_func = function(note)
            local out = { date = os.date("%Y-%m-%d"), lastmod = os.date("%Y-%m-%d") }
            -- `note.metadata` contains any manually added fields in the frontmatter.
            -- So here we just make sure those fields are kept in the frontmatter.
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                    out[k] = v
                end
            end
            return out
        end,

        -- overwrite_mappings = true,
        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true, desc = "Follow link" },
            },
            -- Toggle check-boxes.
            ["<leader>nc"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true, desc = "Toggle Checkbox" },
            },
        },
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Update lastmod metadata on save",
        pattern = "*.md",
        group = vim.api.nvim_create_augroup("config_notes", { clear = true }),
        command = "%s/^lastmod: 20.*/lastmod: " .. os.date("%Y-%m-%d") .. "/ | normal! ``",
    })

    vim.keymap.set("n", "<leader>nO", "<cmd>ObsidianOpen<cr>", { noremap = true, desc = "Open" })
    vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { noremap = true, desc = "New Note" })
    vim.keymap.set("n", "<leader>nN", "<cmd>ObsidianNewFromTemplate<cr>", { noremap = true, desc = "New Note (T)" })
    vim.keymap.set("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { noremap = true, desc = "Find" })
    vim.keymap.set("n", "<leader>ng", "<cmd>ObsidianSearch<cr>", { noremap = true, desc = "Grep or Create" })
    vim.keymap.set("n", "<leader>nG", "<cmd>ObsidianTags<cr>", { noremap = true, desc = "Tag Search" })
    vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianToday<cr>", { noremap = true, desc = "Today" })
    vim.keymap.set("n", "<leader>ny", "<cmd>ObsidianYesterday<cr>", { noremap = true, desc = "Yesterday" })
    vim.keymap.set("n", "<leader>nm", "<cmd>ObsidianTemplate<cr>", { noremap = true, desc = "Template" })
    vim.keymap.set(
        "n",
        "<leader>nv",
        "<cmd>ObsidianFollowLink vsplit<cr>",
        { noremap = true, desc = "Follow Vertical" }
    )
    vim.keymap.set(
        "n",
        "<leader>ns",
        "<cmd>ObsidianFollowLink hsplit<cr>",
        { noremap = true, desc = "Follow Horizontal" }
    )
    vim.keymap.set("n", "<leader>nl", "<cmd>ObsidianLinks<cr>", { noremap = true, desc = "Links" })
    vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { noremap = true, desc = "Backlinks" })
    vim.keymap.set("n", "<leader>nT", "<cmd>ObsidianTOC<cr>", { noremap = true, desc = "TOC" })
    vim.keymap.set("v", "<leader>nl", "<cmd>ObsidianLink<cr>", { noremap = true, desc = "Link to File" })
    vim.keymap.set("v", "<leader>nL", "<cmd>ObsidianLinkNew<cr>", { noremap = true, desc = "Link to New File" })
    vim.keymap.set("v", "<leader>ne", "<cmd>ObsidianExtractNote<cr>", { noremap = true, desc = "Extract Note" })
    vim.keymap.set("n", "<leader>ni", "<cmd>ObsidianPasteImg<cr>", { noremap = true, desc = "Paste Image" })
    vim.keymap.set(
        "n",
        "<leader>nr",
        "<cmd>ObsidianRename --dry-run<cr>",
        { noremap = true, desc = "Rename (dry-run)" }
    )
    vim.keymap.set("n", "<leader>nR", "<cmd>ObsidianRename<cr>", { noremap = true, desc = "Rename" })
end

return { init = init }
