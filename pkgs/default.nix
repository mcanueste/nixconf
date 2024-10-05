# Custom packages, can be built using 'nix build .#example'
pkgs: {
  gp-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "gp-nvim";
    version = "3.9.0";
    src = pkgs.fetchFromGitHub {
      owner = "Robitx";
      repo = "gp.nvim";
      rev = "v${version}";
      sha256 = "3tfhahQZPBYbAnRQXtMAnfwr4gH7mdjxtB8ZqrU3au4=";
    };
    meta.homepage = "https://github.com/Robitx/gp.nvim/";
  };
}
