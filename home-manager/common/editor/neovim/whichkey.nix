{
  programs.nixvim.plugins = {
    # TODO: separate spec to plugin files
    which-key = {
      enable = true;
      settings = {
        replace = {
          desc = [
            [
              "<space>"
              "SPACE"
            ]
            [
              "<leader>"
              "SPACE"
            ]
            [
              "<[cC][rR]>"
              "RETURN"
            ]
            [
              "<[tT][aA][bB]>"
              "TAB"
            ]
            [
              "<[bB][sS]>"
              "BACKSPACE"
            ]
          ];
        };

        spec = let
          map = key: name: {
            __unkeyed = key;
            group = name;
            icon = "󰓩 ";
          };
        in [
          (map "<leader>a" "AI")
          (map "<leader>c" "Copilot")
          (map "<leader>d" "DAP")
          (map "<leader>e" "Edit")
          (map "<leader>f" "Find")
          (map "<leader>fs" "Search")
          (map "<leader>l" "LSP")
          (map "<leader>lt" "Telescope")
          (map "<leader>n" "Notes")
          (map "<leader>o" "Open")
          (map "<leader>t" "Toggle")
        ];
      };
    };
  };
}
