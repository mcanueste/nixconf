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
