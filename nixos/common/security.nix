{...}: {
  security = {
    # control system wide priviledges without sudo (action based permissions)
    polkit.enable = true;

    # Whether to enable the RealtimeKit system service, which hands
    # out realtime scheduling priority to user processes on
    # demand. For example, the PulseAudio server uses this to
    # acquire realtime priority.
    rtkit.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further
  # or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
