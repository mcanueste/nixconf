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

# Setup nix on non-nixos systems
setup-nix PROFILE:
  #!/usr/bin/env bash

  set -euo pipefail

  # Install nix using Determinate Systems' installer
  # https://github.com/DeterminateSystems/nix-installer
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

  # Install home-manager temporarily
  nix shell nixpkgs#home-manager

  # Backup exiting bash files
  mkdir ~/.bash_backup
  mv ~/.bashrc ~/.bash_profile ~/.bash_backup/

  # Install home-manager config
  home-manager switch --flake github:mcanueste/nixconf#{{PROFILE}}

  # Setup ssh key
  mkdir ~/.ssh && pushd ~/.ssh && ssh-keygen -t ed25519 && popd
  echo "Add the following public key to your GitHub account:"
  cat ~/.ssh/id_ed25519.pub
  read -p "Press any key after setting up SSH key on GitHub to continue"

  # Clone nixconf
  git clone git@github.com:mcanueste/nixconf.git ~/nixconf
  echo "All set! The nixconf repository has been cloned to ~/nixconf."
  echo "You can now use 'nh' CLI tool to manage your home-manager state."
