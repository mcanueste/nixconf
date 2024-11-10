{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts.lsp_format = "fallback";
      format_on_save.lsp_format = "fallback";
      formatters = {
        shellcheck.command = lib.getExe pkgs.shellcheck;
        shfmt.command = lib.getExe pkgs.shfmt;
        shellharden.command = lib.getExe pkgs.shellharden;
        stylua.command = lib.getExe pkgs.stylua;
        clang_format.command = lib.getExe' pkgs.clang-tools "clang-format";
        gofumpt.command = lib.getExe pkgs.gofumpt;
        goimports.command = lib.getExe' pkgs.gotools "goimports";
        prettier.command = lib.getExe pkgs.nodePackages.prettier;
        prettierd.command = lib.getExe pkgs.prettierd;
        alejandra.command = lib.getExe pkgs.alejandra;
        squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
      };
      formatters_by_ft = {
        bash = ["shellcheck" "shellharden" "shfmt"];
        lua = ["stylua"];
        cpp = ["clang_format"];
        go = ["gofumpt" "goimports"];
        python = ["ruff_format" "ruff_organize_imports" "ruff_fix"];
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        nix = ["alejandra"];
        "_" = ["squeeze_blanks" "trim_whitespace" "trim_newlines"];
      };
    };
  };
}
