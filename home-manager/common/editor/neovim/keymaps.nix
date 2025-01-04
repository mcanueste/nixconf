{
  programs.nixvim = {
    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      # Update jump list on vertical motions (conflicts with flash.nvim)
      # (map ["n"] "k" "(v:count > 0 ? 'm`' . v:count : '') . 'k'" "Move up")
      # (map ["n"] "j" "(v:count > 0 ? 'm`' . v:count : '') . 'j'" "Move down")

      # Clear search with ESC
      (map ["n" "i"] "<esc>" "<cmd>noh<cr><esc>" "Clear Search")

      # Search and replace word under cursor
      (map ["n"] "<leader>eR" ":%s/<C-r><C-w>//gc<Left><Left><Left>" "Replace word under cursor")

      # Delete word without saving to register
      (map ["n"] "<leader>ed" "viw\"_d" "Delete word w/o register")
      (map ["v"] "<leader>ed" "\"_d" "Delete w/o register")

      # Move to the beginning or end of line with H and L
      (map ["n" "v"] "H" "^" "Move beginning of line")
      (map ["n"] "L" "$" "Move end of line")
      (map ["v"] "L" "g_" "Move end of line")

      # Center cursor after jumps
      (map ["n"] "<C-d>" "<C-d>zz" "Center cursor after jump")
      (map ["n"] "<C-u>" "<C-u>zz" "Center cursor after jump")
      (map ["n"] "n" "nzzzv" "Center cursor after jump")
      (map ["n"] "N" "Nzzzv" "Center cursor after jump")

      # Add conceallevel toggle
      (
        map ["n"] "<leader>tu" ''
          function()
            local winnr = vim.api.nvim_get_current_win()
            local conceallevel = vim.api.nvim_win_get_option(winnr, "conceallevel")
            local newconceallevel = math.fmod(conceallevel + 1, 4)
            vim.opt.conceallevel = newconceallevel
          end
        '' "Toggle 'conceallevel'"
      )
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed = "<leader>e";
        group = "Edit";
        icon = "";
      }
      {
        __unkeyed = "<leader>o";
        group = "Open";
        icon = "";
      }
      {
        __unkeyed = "<leader>t";
        group = "Toggle";
        icon = "";
      }
    ];
  };
}
