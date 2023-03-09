return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  dependencies = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required
    {'williamboman/mason.nvim'},           -- Optional
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'saadparwaiz1/cmp_luasnip'}, -- Optional
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  },
  config = function()
    local lsp = require('lsp-zero').preset({
      name = 'minimal',
      set_lsp_keymaps = false,
      manage_nvim_cmp = true,
      suggest_lsp_servers = false,
    })

    -- markdown lsp
    lsp.configure('marksman', {force_setup = true})

    -- toml lsp
    lsp.configure('taplo', {force_setup = true})

    -- yaml lsp
    lsp.configure('yamlls', {force_setup = true})

    -- docker lsp
    lsp.configure('dockerls', {force_setup = true})

    -- ansible lsp
    lsp.configure('ansiblels', {force_setup = true})

    -- terraform lsp
    lsp.configure('terraformls', {force_setup = true})

    -- bash lsp
    lsp.configure('bashls', {force_setup = true})

    -- go lsp
    lsp.configure('gopls', {force_setup = true})

    -- rust lsp
    lsp.configure('rust_analyzer', {force_setup = true})

    -- lua lsp
    lsp.configure('lua_ls', {
      force_setup = true,
      settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
    })

    -- python
    lsp.configure('pyright', {force_setup = true})

    -- nix lsp
    lsp.configure('nil_ls', {force_setup = true})

    lsp.nvim_workspace()
    lsp.setup()
  end
}
