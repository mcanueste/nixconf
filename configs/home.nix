{
  nixconf = {
    user = {
      username = "mcst";
      home = "/home/mcst";
    };

    browser = {
      brave = true;
      firefox = false;
      chrome = false;
    };

    media = {
      spotify = true;
      zotero = false;
      calibre = true;
    };

    chat = {
      telegram = true;
      discord = true;
      teams = false;
      slack = false;
    };

    font = {
      enable = true;
      fonts = ["JetBrainsMono"];
    };

    desktop = {
      sway = true;
      waybar = true;
      rofi = true;
      dunst = true;
    };

    editor = {
      neovim = true;
      obsidian = true;
      datagrip = false;
      pycharm = false;
    };
  };
}
