{
  programs.nixvim.plugins = {
    which-key = {
      enable = true;
      settings.spec = let
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
        (map "<leader>g" "Git")
        (map "<leader>gt" "Toggle")
        (map "<leader>h" "Arrow")
        (map "<leader>l" "LSP")
        (map "<leader>lt" "Telescope")
        (map "<leader>n" "Notes")
        (map "<leader>o" "Open")
        (map "<leader>t" "Toggle")
      ];
    };
  };
}
