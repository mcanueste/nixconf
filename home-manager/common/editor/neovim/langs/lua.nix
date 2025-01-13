{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.lua_ls = {
      enable = true;
      settings = {
        telemetry.enable = false;
        format.enable = false;
        completion.callSnippet = "Replace";
        diagnostics.disable = ["missing-fields"];
      };
    };

    conform-nvim.settings = {
      formatters.stylua.command = lib.getExe pkgs.stylua;
      formatters_by_ft.lua = ["stylua"];
    };
  };
}
