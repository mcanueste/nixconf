{
  programs.nixvim = {
    plugins = {
      gitlinker.enable = true;
      gitblame = {
        enable = true;
        settings.delay = 1000;
      };
      diffview = {
        enable = true;
        enhancedDiffHl = true;
      };

      which-key.settings.spec = [
        {
          __unkeyed = "<leader>g";
          group = "Git";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>gy";
          desc = "Create Link";
          mode = "n";
        }
      ];
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      (map ["n"] "<leader>gb" "<cmd>GitBlameToggle<cr>" "Toggle Blame")
      (map ["n"] "<leader>go" "<cmd>DiffviewOpen<cr>" "Diffview Open")
      (map ["n"] "<leader>gc" "<cmd>DiffviewClose<cr>" "Diffview Close")
      (map ["n"] "<leader>gr" "<cmd>DiffviewRefresh<cr>" "Diffview Refresh")
      (map ["n"] "<leader>gt" "<cmd>DiffviewToggleFiles<cr>" "Diffview Toggle Files")
      (map ["n"] "<leader>gf" "<cmd>DiffviewFileHistory<cr>" "Diffview File History")
      (map ["v"] "<leader>gf" "<cmd>'<,'>DiffviewFileHistory<cr>" "Diffview File History")
      (map ["n"] "<leader>gF" "<cmd>DiffviewFocusFiles<cr>" "Diffview Focus Files")
    ];
  };
}
