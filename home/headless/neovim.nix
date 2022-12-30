{ pkgs, ... }:
{
  programs.neovim= {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true; 
    plugins = with pkgs.vimPlugins; [
      { 
        plugin = rose-pine;
	config = "colorscheme rose-pine";
      }
    ];
  };
}
