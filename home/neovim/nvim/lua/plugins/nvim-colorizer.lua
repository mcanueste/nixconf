-- indent guides for Neovim
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  config = function ()
    require('colorizer').setup()
  end
}
