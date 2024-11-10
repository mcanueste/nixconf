{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      linters = {
        hadolint.cmd = lib.getExe pkgs.hadolint;
      };
      lintersByFt = {
        # bash: lsp is enough
        # lua: lsp is enough
        # go: lsp is enough
        # python: lsp is enough
        # rust: lsp is enough
        # ts: lsp is enough
        dockerfile = ["hadolint"];
        # TODO: terraform later
        # TODO: json/yaml later
      };
    };

    autoGroups.customLint.clear = true;
    autoCmd = [
      {
        desc = "Try linting on BufWritePost";
        group = "customLint";
        event = "BufWritePost";
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      }
    ];
  };
}
