{
  nixos.network.wireguard = {
    enable = true;
    configs = [
      {
        kreo = {
          address = ["10.45.0.30/32"];
          dns = ["10.41.0.2"];
          privateKeyFile = "/home/mcst/.ssh/wireguard/privatekey";
          peers = [
            {
              publicKey = "4HvNXgrqfGeFkhFBXjJelFu+uDcvepN+o0bIdCgUBWw=";
              allowedIPs = ["10.41.0.0/16" "10.42.21.0/24"];
              endpoint = "3.74.48.98:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      }
    ];
  };
}
