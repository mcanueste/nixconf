{ ... }:
{
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
    };
  };
}
