local telescope = require("telescope.builtin")
local whichkey = require("which-key")
local obsidian = require("obsidian")
local utils = require("config.utils")

local function init()
    local home = vim.fn.expand("$HOME")
    local vault_path = home .. "/notes"
    local capture_path = home .. "/notes/capture"

    ---@diagnostic disable-next-line: missing-fields
    local client = obsidian.setup({
        dir = vault_path,
        log_level = vim.log.levels.INFO,
        open_notes_in = "vsplit",
        disable_frontmatter = true,
        daily_notes = {
            folder = "journal",
            date_format = "%Y-%m-%d",
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
            -- Where to put new notes created from completion. Valid options are
            --  * "current_dir" - put new notes in same directory as the current buffer.
            --  * "notes_subdir" - put new notes in the default notes subdirectory.
            new_notes_location = "current_dir",
            -- Whether to add the output of the node_id_func to new notes in autocompletion.
            -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
            prepend_note_id = true,
        },
        templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {},
        },
        note_id_func = function(title)
            -- If title is not given, use ISO timestamp, otherwise use as is
            if title == nil then
                return tostring(os.date("%y%m%d%H%M%S"))
            end
            return title
        end,
        note_frontmatter_func = function(note)
            -- disable frontmatter for journal and capture notes
            if string.match(tostring(note.path), "/capture") then
                return {}
            end
            if string.match(tostring(note.path), "/journal") then
                return {}
            end

            local out = { date = os.date("%Y-%m-%d"), lastmod = os.date("%Y-%m-%d") }
            -- `note.metadata` contains any manually added fields in the frontmatter.
            -- So here we just make sure those fields are kept in the frontmatter.
            if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
                for k, v in pairs(note.metadata) do
                    out[k] = v
                end
            end
            return out
        end,
        overwrite_mappings = true,
        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true, desc = "Follow link" },
            },
        },
    })

    --- Create a note
    --
    ---@param subdir string?
    ---@param ask_name boolean?
    ---@param template string?
    ---@return nil
    local function new_note(subdir, ask_name, template)
        -- get file name, otherwise use ISO timestamp
        local fname = ""
        if ask_name == true then
            inp = vim.fn.input("Name: ", "")
            if inp == "" then
                return
            end
            fname = inp
        else
            fname = tostring(os.date("%y%m%d%H%M%S"))
        end

        -- create query to check if note already exists
        local query = fname .. ".md"
        if subdir ~= nil then
            query = subdir .. "/" .. fname .. ".md"
        end

        -- try to find the note, and create if not found
        local note = client:resolve_note(query)
        if note == nil then
            note = client:new_note(fname, fname, client.dir .. "/" .. subdir)
        end

        -- create a split and open note
        vim.cmd("vsplit")
        vim.cmd("edit " .. tostring(note.path))
        if template ~= nil then
            vim.cmd("ObsidianTemplate " .. tostring(note.path) .. ".md")
        end
    end

    whichkey.register({ n = { name = "notes" } }, { prefix = "<leader>" })
    vim.keymap.set("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { noremap = true, desc = "Find" })
    vim.keymap.set("n", "<leader>ng", "<cmd>ObsidianSearch<cr>", { noremap = true, desc = "Grep" })
    vim.keymap.set("n", "<leader>nB", "<cmd>ObsidianBacklinks<cr>", { noremap = true, desc = "Backlinks" })
    vim.keymap.set("n", "<leader>no", "<cmd>ObsidianOpen<cr>", { noremap = true, desc = "Open" })
    vim.keymap.set("n", "<leader>nT", "<cmd>ObsidianTemplate<cr>", { noremap = true, desc = "Template" })
    vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianToday<cr>", { noremap = true, desc = "Today" })
    vim.keymap.set("n", "<leader>ny", "<cmd>ObsidianYesterday<cr>", { noremap = true, desc = "Yesterday" })
    vim.keymap.set("n", "<leader>nN", function()
        new_note(nil, true, "basic")
    end, { noremap = true, desc = "Permanent Note" })
    vim.keymap.set("n", "<leader>nn", function()
        new_note("capture", false, nil)
    end, { noremap = true, desc = "Capture Note" })
    vim.keymap.set("n", "<leader>nd", function()
        new_note("devlog", true, "devlog")
    end, { noremap = true, desc = "DevLog Note" })
    vim.keymap.set("n", "<leader>np", function()
        new_note("projects", true, "project")
    end, { noremap = true, desc = "Project Note" })
    vim.keymap.set("n", "<leader>nb", function()
        new_note("blog", true, "blog")
    end, { noremap = true, desc = "Blog Note" })
    vim.keymap.set("n", "<leader>nP", function()
        new_note("blog", true, "blog-project")
    end, { noremap = true, desc = "Blog Project Note" })
end

return { init = init }
