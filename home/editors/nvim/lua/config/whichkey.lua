local whichkey = require("which-key")

local function init()
    whichkey.setup()
    whichkey.register({ u = { name = "ui" } }, { prefix = "<leader>" })
    whichkey.register({ g = { name = "goto++" } }, { prefix = "<leader>" })
    whichkey.register({ f = { name = "find" } }, { prefix = "<leader>" })
    whichkey.register({ s = { name = "search" } }, { prefix = "<leader>" })
    whichkey.register({ o = { name = "open" } }, { prefix = "<leader>" })
    whichkey.register({ l = { name = "lsp" } }, { prefix = "<leader>" })
    -- whichkey.register({ lf = { name = "fuzzy" } }, { prefix = "<leader>" })
    whichkey.register({ v = { name = "vcs" } }, { prefix = "<leader>" })
    whichkey.register({ h = { name = "harpoon" } }, { prefix = "<leader>" })
end

return { init = init }
