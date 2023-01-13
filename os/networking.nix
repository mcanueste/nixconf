{ ... }:
{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    # wifi.backend = "iwd"; 
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.45.0.30/32" ];
      dns = [ "10.41.0.2" ];
      privateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
      
      peers = [
        {
          publicKey = "4HvNXgrqfGeFkhFBXjJelFu+uDcvepN+o0bIdCgUBWw=";
          allowedIPs = [ "10.41.0.0/16" ];
          endpoint = "3.74.48.98:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
