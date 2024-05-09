{config, ...}: let
  shellAliases = {
    nsw = "sudo nixos-rebuild switch --flake ~/Projects/personal/nixconf/";
    ngc = "sudo nix-collect-garbage";
    nfu = "nix flake update";
  };
in {
  home-manager.users.${config.nixconf.system.user} = {
    programs.bash = {inherit shellAliases;};
    programs.zsh = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
  };
}
