{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    typescript-tools.enable = true;

    conform-nvim.settings = {
      formatters = {
        prettier.command = lib.getExe pkgs.nodePackages.prettier;
        prettierd.command = lib.getExe pkgs.prettierd;
      };

      formatters_by_ft = {
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
      };
    };
  };
}
