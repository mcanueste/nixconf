return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v1.x",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" }, -- Required
    -- {'williamboman/mason.nvim'},           -- handle with nix
    -- {'williamboman/mason-lspconfig.nvim'}, -- handle with nix

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },         -- Required
    { "hrsh7th/cmp-nvim-lsp" },     -- Required
    { "hrsh7th/cmp-buffer" },       -- Optional
    { "hrsh7th/cmp-path" },         -- Optional
    { "saadparwaiz1/cmp_luasnip" }, -- Optional
    { "hrsh7th/cmp-nvim-lua" },     -- Optional

    -- Snippets
    { "L3MON4D3/LuaSnip" },             -- Required
    { "rafamadriz/friendly-snippets" }, -- Optional
  },
  keys = {
    { "<leader>ol", "<cmd>LspInfo<cr>", desc = "LSP Info" },
  },
  config = function()
    local lsp = require("lsp-zero").preset({
      name = "minimal",
      set_lsp_keymaps = false,
      manage_nvim_cmp = true,
      suggest_lsp_servers = false,
    })
    -- markdown lsp
    lsp.configure("marksman", { force_setup = true })
    -- toml lsp
    lsp.configure("taplo", { force_setup = true })
    -- yaml lsp
    lsp.configure("yamlls", { force_setup = true })
    -- docker lsp
    lsp.configure("dockerls", { force_setup = true })
    -- ansible lsp
    lsp.configure("ansiblels", { force_setup = true })
    -- terraform lsp
    lsp.configure("terraformls", { force_setup = true })
    -- bash lsp
    lsp.configure("bashls", { force_setup = true })
    -- go lsp
    lsp.configure("gopls", { force_setup = true })
    -- rust lsp
    lsp.configure("rust_analyzer", { force_setup = true })
    -- lua lsp
    lsp.configure("lua_ls", {
      force_setup = true,
      settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    })
    -- python
    lsp.configure("pyright", { force_setup = true })
    -- nix lsp
    lsp.configure("nil_ls", { force_setup = true })
    lsp.nvim_workspace()
    lsp.on_attach(function(_, bufnr)
      local opts = function(desc)
        return { buffer = bufnr, remap = false, desc = desc }
      end
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show Docs"))
      vim.keymap.set("n", "<Ctrl-k>", vim.lsp.buf.signature_help, opts("Show Signature"))

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Goto definition"))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Goto declaration"))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Goto implementation"))
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts("Goto type definition"))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Next diagnostic"))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Previous diagnostic"))

      vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts("Show diagnostic"))
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename"))
      vim.keymap.set("n", "<leader>cs", function()
        vim.lsp.buf.workspace_symbol()
      end, opts("List workspace symbol"))

      vim.keymap.set("n", "<space>cwa", vim.lsp.buf.add_workspace_folder, opts("Add to workspace folders"))
      vim.keymap.set("n", "<space>cwr", vim.lsp.buf.remove_workspace_folder, opts("Remove from workspace folders"))
      vim.keymap.set("n", "<space>cwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts("List workspace folders"))
    end)
    lsp.setup()
    vim.diagnostic.config({
      virtual_text = true,
    })
  end,
}
