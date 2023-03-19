{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlay = final: prev: {};
      overlays = [overlay];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {allowUnfree = true;};
      };
      fhsShell = pkgs.buildFHSUserEnv {
        name = "pyflake";
        targetPkgs = pkgs: [
          pkgs.poetry
          pkgs.python310
        ];
        runScript = "fish";
      };
    in rec {
      inherit overlay overlays;
      devShell = fhsShell.env;
    });
}
