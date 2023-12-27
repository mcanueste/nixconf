{config, ...}: let
  shellAliases = {
    nsw = "sudo nixos-rebuild switch --flake ~/nixconf/";
    ngc = "sudo nix-collect-garbage";
    nfu = "nix flake update";
  };
in {
  home-manager.users.${config.nixconf.user} = {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
  };
}
