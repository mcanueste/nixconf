{
  services.xserver = {
    # Enable touchpad support
    libinput.enable = true;

    # Configure keymap in X11
    layout = "us,de";
    xkbOptions = "caps:swapescape";
  };
  console.useXkbConfig = true;
}
