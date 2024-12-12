# nixos
NixOS and Home Manager configurations

## Setting up nix package manager

First install `just`, i.e. in Fedora:

```bash
sudo dnf install just
```

Then clone the `justfile` to the current working directory.

```bash
curl -o ./justfile https://raw.githubusercontent.com/mcanueste/nixconf/refs/heads/main/justfile
```

Afterward, check the `home-manager` profiles on `flake.nix`, and then setup nix

```bash
just setup-nix mcst@fedora
```

Then cleanup the `just` and `justfile` since we will be using `nix` installed just system-wide, and the
`justfile` will be cloned along with `nixconf` repo to `~/nixconf/justfile`.
