{
  programs.nixvim = {
    plugins = {
      flash = {
        enable = true;
        settings = {
          # jump.nohlsearch = true;
          # jump.autojump = true;
          modes = {
            search.enabled = false;
          };
        };
      };
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      (map ["n" "x" "o"] "s" {__raw = "function() require('flash').jump() end";} "Flash")
      (map ["n" "x" "o"] "S" {__raw = "function() require('flash').treesitter() end";} "Flash Treesitter")
      (map ["x" "o"] "R" {__raw = "function() require('flash').treesitter_search() end";} "Treesitter Search")
    ];
  };
}