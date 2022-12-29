{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [
        (import ./overlays/rose_pine_tmux.nix)
        (import ./overlays/tmux_session_wizard.nix)
      ];
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./os
          home-manager.nixosModules.home-manager
          {
	    nixpkgs = { inherit pkgs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mcst = import ./home;
          }
        ];
      };
    };
  };
}
