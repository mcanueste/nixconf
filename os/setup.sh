#! /usr/bin/env bash
sudo cp /etc/nixos/hardware-configuration.nix .
sudo mv /etc/nixos/configuration.nix configuration.nix.bak
sudo ln -s $(pwd)/configuration.nix /etc/nixos/configuration.nix
