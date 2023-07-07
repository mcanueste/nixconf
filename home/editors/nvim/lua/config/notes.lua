local telescope = require("telescope.builtin")
local capture = require("capture")

local function init()
    vim.keymap.set("n", "<leader>nn", function()
        capture.capture()
    end, { noremap = true, desc = "Capture" })
    vim.keymap.set("n", "<leader>ng", function()
        telescope.live_grep("~/projects/notes/capture/")
    end, { noremap = true, desc = "Grep" })
end

return { init = init }
