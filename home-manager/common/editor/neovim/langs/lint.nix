{...}: {
  programs.nixvim = {
    plugins.lint.enable = true;
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
