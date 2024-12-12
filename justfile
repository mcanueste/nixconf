# Display help information
default:
  @just --list

# Rebuild the system
switch:
  sudo nixos-rebuild switch --flake .

# Update flake lock
update:
  nix flake update

# Collect garbage
gc:
  sudo nix-collect-garbage

# Collect garbage with generation cleanup
gcd:
  sudo nix-collect-garbage -d

setup-nix PROFILE:
  #!/usr/bin/env bash

  set -euo pipefail

  # Install nix using Determinate Systems' installer
  # https://github.com/DeterminateSystems/nix-installer
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install

  # Install home-manager temporarily
  nix shell nixpkgs#home-manager

  # Backup exiting bash files
  mkdir ~/.bash_backup
  mv ~/.bashrc ~/.bash_profile ~/.bash_backup/

  # Install home-manager config
  home-manager switch --flake github:mcanueste/nixconf#{{PROFILE}}
