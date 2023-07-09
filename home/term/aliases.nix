let
  shellAliases = {
    nsw = "sudo nixos-rebuild switch --flake ~/nix/nixconf/";
    ngc = "sudo nix-collect-garbage";
    nfu = "nix flake update";
  };
in {
  programs.bash = {
    inherit shellAliases;
  };
  programs.fish = {
    inherit shellAliases;
  };
}
