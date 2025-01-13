{...}: {
  programs.nixvim.plugins = {
    lsp.servers = {
      ruff.enable = true;

      pyright = {
        enable = true;
        settings.pyright.analysis = {
          autoSearchPaths = true;
          diagnosticMode = "openFilesOnly";
          useLibraryCodeForTypes = true;
        };
      };
    };

    conform-nvim.settings.formatters_by_ft.python = ["ruff_format" "ruff_organize_imports" "ruff_fix"];

    dap.extensions.dap-python.enable = true;
  };
}
