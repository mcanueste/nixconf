{
  programs.nixvim.plugins = {
    tmux-navigator.enable = true;
    guess-indent.enable = true;
    nvim-autopairs = {
      enable = true;
      settings.disable_filetype = ["TelescopePrompt"];
    };
  };
}
