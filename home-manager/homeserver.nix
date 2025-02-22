{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "homeserver";
      stateVersion = "24.11";
      flakePath = "/home/${username}/nixconf";

      browsers.brave = true;

      media.spotify = true;

      packages = {
        docker-compose = true;
        lazydocker = true;
        dive = true;
      };
    };
  };
}
