{ ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mcst = {
    isNormalUser = true;
    description = "mcst";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
