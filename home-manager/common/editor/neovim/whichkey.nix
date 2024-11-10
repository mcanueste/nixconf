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
      };
    };
  };
}
