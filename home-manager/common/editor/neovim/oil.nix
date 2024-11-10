{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        delete_to_trash = true;
        skip_confirm_for_simple_edits = false;
        view_options.show_hidden = true;
        columns = [
          "icon"
          "permissions"
          "size"
          "mtime"
        ];
        use_default_keymaps = false;
        keymaps = {
          "<CR>" = "actions.select";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "`" = "actions.cd";
          "~" = "actions.tcd";
          "<leader>b?" = "actions.show_help";
          "<leader>bv" = "actions.select_vsplit";
          "<leader>bs" = "actions.select_split";
          "<leader>bp" = "actions.preview";
          "<leader>bq" = "actions.close";
          "<leader>br" = "actions.refresh";
          "<leader>bS" = "actions.change_sort";
          "<leader>bo" = "actions.open_external";
          "<leader>bh" = "actions.toggle_hidden";
          "<leader>bt" = "actions.toggle_trash";
        };
      };
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      (map ["n"] "<leader>oe" "<cmd>Oil<cr>" "Oil")
    ];
  };
}
