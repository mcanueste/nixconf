{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.bashls = {
      enable = true;
      settings.bashIde.globPattern = "*@(.sh|.inc|.bash|.command)";
    };

    conform-nvim.settings = {
      formatters = {
        shellcheck.command = lib.getExe pkgs.shellcheck;
        shfmt.command = lib.getExe pkgs.shfmt;
        shellharden.command = lib.getExe pkgs.shellharden;
      };

      formatters_by_ft.bash = ["shellcheck" "shellharden" "shfmt"];
    };
  };
}
