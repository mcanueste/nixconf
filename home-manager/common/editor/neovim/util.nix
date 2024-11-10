{
  programs.nixvim.plugins = {
    tmux-navigator.enable = true;
    sleuth.enable = true;
    nvim-autopairs = {
      enable = true;
      settings.disable_filetype = ["TelescopePrompt"];
    };
  };
}
