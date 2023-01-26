{pkgs, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];
}
