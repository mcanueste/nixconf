{
  inputs,
  system,
  ...
}: {
  # Fuse filesystem that returns symlinks to executables based on the PATH
  # of the requesting process. This is useful to execute shebangs on NixOS
  # that assume hard coded locations in locations like /bin or /usr/bin etc.
  services.envfs.enable = true;

  # https://github.com/thiagokokada/nix-alien
  # $ nix-alien myapp            # Run the binary inside a FHS shell with all needed shared dependencies to execute the binary
  # $ nix-alien-ld myapp         # Spawns you inside a shell with NIX_LD_LIBRARY_PATH set to the needed dependencies, to be used with nix-ld
  # $ nix-alien-find-libs myapp  # Lists all libs needed for the binary
  environment.systemPackages = [
    inputs.nix-alien.packages.${system}.nix-alien
  ];

  programs.nix-ld = {
    enable = true;
    libraries = [
      # TODO: add libraries as you need them in the future
    ];
  };
}
