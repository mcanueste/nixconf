{config, ...}: {
  programs.nixvim = {
    plugins = {
      fidget.enable = true;

      typescript-tools.enable = true;

      rustaceanvim = {
        enable = true;
        settings = {
          server.default_settings = {
            rust-analyzer = {
              check.command = "clippy";
              inlayHints.lifetimeElisionHints.enable = "always";
            };
          };
          tools = {
            enable_clippy = true;
            enable_nextest = true;
          };
          dap.autoload_configurations = true;
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;

        preConfig = ''
          -- Change diagnostic symbols in the sign column (gutter)
          local signs = { Error = '', Warn = '', Hint = '', Info = '' }
          for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        '';

        keymaps = let
          map = action: desc: {inherit action desc;};
        in {
          diagnostic = {
            "gl" = map "open_float" "Line Diagnostics";
          };
          lspBuf = {
            "K" = map "hover" "Hover";
            "gk" = map "signature_help" "Signature";
            "ga" = map "code_action" "Code Action";
            "gd" = map "definition" "Definition";
            "gD" = map "declaration" "Declaration";
            "gi" = map "implementation" "Implementation";
            "gy" = map "type_definition" "Type Definition";
            "gr" = map "references" "References";
            "gR" = map "rename" "Rename";
          };
          extra = [
            {
              mode = "n";
              key = "<leader>li";
              action.__raw = ''
                function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                end
              '';
              options = {desc = "Toggle Inlay Hints";};
            }
          ];
        };

        servers = {
          bashls = {
            enable = true;
            settings.bashIde.globPattern = "*@(.sh|.inc|.bash|.command)";
          };

          dockerls = {
            enable = true;
            settings.docker.languageserver.formatter.ignoreMultilineInstructions = true;
          };

          terraformls.enable = true;

          lua_ls = {
            enable = true;
            settings = {
              telemetry.enable = false;
              format.enable = false;
              completion.callSnippet = "Replace";
              diagnostics.disable = ["missing-fields"];
            };
          };

          golangci_lint_ls.enable = true;

          gopls = {
            enable = true;
            settings.gopls.usePlaceholders = true;
          };

          ruff.enable = true;

          pyright = {
            enable = true;
            settings.pyright.analysis = {
              autoSearchPaths = true;
              diagnosticMode = "openFilesOnly";
              useLibraryCodeForTypes = true;
            };
          };

          nixd = {
            enable = true;
            settings = {
              formatting.command = ["alejandra"];
              nixpkgs.expr = "import (builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").inputs.nixpkgs { }";
              options = {
                nixos.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").nixosConfigurations.nixos.options";
                home-manager.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").homeConfigurations.\"${config.nixconf.username}@nixos\".options";
              };
            };
          };
        };
      };

      which-key.settings.spec = [
        {
          __unkeyed = "<leader>l";
          group = "LSP";
          icon = "";
        }
      ];
    };

    autoGroups = {
      customLspAttach.clear = true;
      customLspHighlight.clear = true;
      customLspHighlightDetach.clear = true;
    };

    autoCmd = [
      {
        # desc = "Highlight references to word under cursor in LSP buffers";
        desc = "Autocommands to enable when LSP attaches";
        group = "customLspAttach";
        event = "LspAttach";
        callback.__raw = ''
          function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then

              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = 'customLspHighlight',
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = 'customLspHighlight',
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = 'customLspHighlightDetach',
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'customLspHighlight', buffer = event2.buf }
                end,
              })
            end
          end
        '';
      }
    ];
  };
}