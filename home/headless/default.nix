{pkgs, ...}: {
  imports = [
    ./packages.nix
    ./tmux.nix
    ./bash.nix
    ./dircolors.nix
    ./git.nix
    ./exa.nix
    ./bat.nix
    ./fzf.nix
    ./zoxide.nix
    ./neovim.nix
    ./direnv.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    ZK_NOTEBOOK_DIR = "~/Projects/notes";
  };
}
