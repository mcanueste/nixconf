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
      formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
      formatters_by_ft."_" = ["squeeze_blanks" "trim_whitespace" "trim_newlines"];
    };
  };
}
