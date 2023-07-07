local function init()
    require("config.basics").init()
    require("config.theme").init()
    require("config.whichkey").init()
    require("config.telescope").init()
    require("config.gitsigns").init()
    require("config.tools").init()
    require("config.treesitter").init()
    require("config.languages").init()
    require("config.notes").init()
end

return { init = init }
