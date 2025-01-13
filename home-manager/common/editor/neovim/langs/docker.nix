{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.dockerls = {
      enable = true;
      settings.docker.languageserver.formatter.ignoreMultilineInstructions = true;
    };

    lint = {
      linters.hadolint.cmd = lib.getExe pkgs.hadolint;
      lintersByFt.dockerfile = ["hadolint"];
    };
  };
}
