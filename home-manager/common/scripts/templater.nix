{
  pkgs,
  lib,
  config,
  ...
}: {
  config = let
    temp = pkgs.writeShellApplication {
      name = "temp";
      text = ''
        #!/usr/bin/env bash
        echo "Setting up template: $1..."
        nix flake --tarball-ttl 0 init -t "github:mcanueste/templates#$1"
        echo "Done!"
      '';
    };
  in
    lib.mkIf config.nixconf.scripts.enable {
      home.packages = [
        temp
      ];
    };
}
