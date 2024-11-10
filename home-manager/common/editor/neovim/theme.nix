{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          diffview = true;
          blink_cmp = true;
          which_key = true;
          lsp_trouble = true;
          mini.indentscope_color = "lavender";
        };
      };
    };

    plugins = {
      lualine.enable = true;
      dressing.enable = true;
    };
  };
}
