{
  services.xserver = {
    # Configure keymap in X11
    layout = "us,de";
    xkbOptions = "ctrl:swapcaps";
  };
  console.useXkbConfig = true;
}
