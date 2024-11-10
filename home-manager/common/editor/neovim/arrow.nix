{
  programs.nixvim.plugins = {
    arrow = {
      enable = true;
      settings = {
        show_icons = true;
        index_keys = "asdfgqwert";
        leader_key = "<leader>h";
        buffer_leader_key = "<leader>m";
        mappings = {
          quit = "esc";
          toggle = "h";
          edit = "z";
          remove = "x";
          delete_mode = "X";
          clear_all_items = "C";
          open_vertical = "v";
          open_horizontal = "S";
          next_item = "]";
          prev_item = "[";
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>h";
        desc = "Arrow";
        icon = "󰣉";
        mode = "n";
      }
      {
        __unkeyed-1 = "<leader>m";
        desc = "Arrow Buffer";
        icon = "󰣉";
        mode = "n";
      }
    ];
  };
}
