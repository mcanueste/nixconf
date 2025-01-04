{
  programs.nixvim.plugins = {
    friendly-snippets.enable = true;

    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          "<C-space>" = ["show" "show_documentation" "hide_documentation"];
          "<C-e>" = ["hide"];
          "<C-y>" = ["accept" "fallback"];
          "<Tab>" = ["snippet_forward" "fallback"];
          "<S-Tab>" = ["snippet_backward" "fallback"];
          "<Up>" = ["select_prev" "fallback"];
          "<Down>" = ["select_next" "fallback"];
          "<C-p>" = ["select_prev" "fallback"];
          "<C-n>" = ["select_next" "fallback"];
          "<C-b>" = ["scroll_documentation_up" "fallback"];
          "<C-f>" = ["scroll_documentation_down" "fallback"];
        };
        appearance = {
          nerd_font_variant = "mono";
          use_nvim_cmp_as_default = true;
        };
        completion.accept.auto_brackets.enabled = true;
        signature.enabled = true;
      };
    };

    lsp.capabilities =
      # lua
      ''
        -- Note: this function is called during LSP lua setup inside a function defining the default
        -- `capabilities`, and returning it.
        -- See https://github.com/nix-community/nixvim/blob/898246c943ba545a79d585093e97476ceb31f872/plugins/lsp/default.nix#L240C13-L240C71
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
      '';
  };
}
