{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers = {
      golangci_lint_ls.enable = true;

      gopls = {
        enable = true;
        settings.gopls.usePlaceholders = true;
      };
    };

    conform-nvim = {
      settings = {
        formatters = {
          gofumpt.command = lib.getExe pkgs.gofumpt;
          goimports.command = lib.getExe' pkgs.gotools "goimports";
        };

        formatters_by_ft.go = ["gofumpt" "goimports"];
      };
    };

    dap.extensions.dap-go = {
      enable = true;
      delve.path = lib.getExe' pkgs.delve "dlv";
    };
  };
}
