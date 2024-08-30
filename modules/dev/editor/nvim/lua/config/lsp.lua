local function init()
    -- LSP
    -- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig

    require("config.autocommands").close_with_q("lspinfo", { "lspinfo" })

    -- LspAttach mappings
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- NOTE: Some keybingds are set with trouble

            -- Enable completion triggered by <c-x><c-o>
            -- Also see: https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#golang-gopls
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
            vim.bo[ev.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
            vim.bo[ev.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"

            -- enable inlays on attach
            vim.lsp.inlay_hint.enable(true)

            local function opts(desc)
                return { buffer = ev.buf, desc = desc }
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover [LSP]"))
            vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts("Signature [LSP]"))
            vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts("Rename [LSP]"))
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts("Line Diagnostics"))
            vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code Action [LSP]"))
            vim.keymap.set("n", "gh", function()
                vim.lsp.buf.format({ async = true })
            end, opts("Format"))

            -- Workspace keymaps
            vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts("Workspace Add"))
            vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts("Workspace Remove"))
            vim.keymap.set("n", "<leader>lwl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts("Workspace List"))

            -- Inlay hints
            vim.keymap.set("n", "<leader>li", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, opts("Toggle Inlay Hints"))
        end,
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- TODO: yaml and json based: docker-compose, ansible
    -- TODO: Setup jsonls https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#jsonls

    ---------------------- htmx
    -- lspconfig.htmx.setup({ capabilities = capabilities }) -- Currently buggy with the LSP version

    ---------------------- bash
    lspconfig.bashls.setup({
        capabilities = capabilities,
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
        },
    })

    ---------------------- docker
    lspconfig.dockerls.setup({
        capabilities = capabilities,
        settings = {
            docker = {
                languageserver = {
                    formatter = {
                        ignoreMultilineInstructions = true,
                    },
                },
            },
        },
    })

    ---------------------- terraform
    lspconfig.terraformls.setup({ capabilities = capabilities })

    ---------------------- python
    lspconfig.ruff.setup({ capabilities = capabilities }) -- newer version compared to ruff_lsp (alpha)
    lspconfig.basedpyright.setup({
        capabilities = capabilities,
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    })

    ---------------------- ocaml
    lspconfig.ocamllsp.setup({ capabilities = capabilities })

    ---------------------- ocaml
    -- lspconfig.nickel_ls.setup({ capabilities = capabilities })

    ---------------------- Nix
    lspconfig.nil_ls.setup({
        capabilities = capabilities,
        autostart = true,
        settings = {
            ["nil"] = {
                formatting = {
                    command = { "alejandra" },
                },
                nix = {
                    flake = {
                        -- Auto-archiving behavior which may use network.
                        autoArchive = false,
                        -- Whether to auto-eval flake inputs.
                        autoEvalInputs = false,
                    },
                },
            },
        },
    })

    ---------------------- Go
    lspconfig.golangci_lint_ls.setup({ capabilities = capabilities })
    lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },

        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                staticcheck = true,
                usePlaceholders = true,
                completeUnimported = true,
                experimentalPostfixCompletions = true,
                gofumpt = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
            },
            hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                functionTypeParameters = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    })

    ---------------------- Rust
    -- Automatically done via rustaceanvim
    -- https://github.com/mrcjkb/rustaceanvim
    -- TODO: might need rust specific key maps
    vim.g.rustaceanvim = {
        server = {
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        bindingModeHints = {
                            enable = false,
                        },
                        chainingHints = {
                            enable = true,
                        },
                        closingBraceHints = {
                            enable = true,
                            minLines = 25,
                        },
                        closureReturnTypeHints = {
                            enable = "never",
                        },
                        lifetimeElisionHints = {
                            enable = "never",
                            useParameterNames = false,
                        },
                        maxLength = 25,
                        parameterHints = {
                            enable = true,
                        },
                        reborrowHints = {
                            enable = "never",
                        },
                        renderColons = true,
                        typeHints = {
                            enable = true,
                            hideClosureInitialization = false,
                            hideNamedConstructor = false,
                        },
                    },
                },
            },
        },
    }

    ---------------------- Lua
    require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
        override = function(root_dir, library)
            -- if using nix (with or without flake)
            if root_dir:find("/etc/nixos", 1, true) == 1 or root_dir:find("/nix/store", 1, true) == 1 then
                library.enabled = true
                library.plugins = true
            end
        end,
    })

    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
            Lua = {
                telemetry = { enable = false },
                format = { enable = false }, -- using stylua with null-ls
                completion = {
                    callSnippet = "Replace",
                },
                hint = { enable = true },
            },
        },
    })
end

return { init = init }
