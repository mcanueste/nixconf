{...}: {
  programs.nixvim = {
    plugins = {
      fidget.enable = true;

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
