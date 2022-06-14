{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];
}
