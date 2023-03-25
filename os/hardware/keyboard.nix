{
  services.xserver = {
    # Enable touchpad support
    libinput.enable = true;

    # Configure keymap in X11
    layout = "us,de";
    xkbOptions = "ctrl:swapcaps";
  };
  console.useXkbConfig = true;
}
