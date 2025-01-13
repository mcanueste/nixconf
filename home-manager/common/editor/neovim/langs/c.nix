{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins.conform-nvim.settings = {
    formatters.clang_format.command = lib.getExe' pkgs.clang-tools "clang-format";
    formatters_by_ft.cpp = ["clang_format"];
  };
}
