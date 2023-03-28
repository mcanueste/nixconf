{
  services.xserver = {
    # Enable touchpad support
    libinput.enable = true;

    # Configure keymap in X11
    layout = "us,de";
    xkbModel = "pc105";
    # xkbVariant = "qwerty";
    xkbOptions = "caps:swapescape,grp:win_space_toggle";
  };
  console.useXkbConfig = true;
}