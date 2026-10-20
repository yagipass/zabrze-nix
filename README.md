# zabrze-nix

> [!WARNING]
> This repository is no longer maintained and has been archived.

Nix packaging for [Ryooooooga/zabrze](https://github.com/Ryooooooga/zabrze), a zsh abbreviation expansion plugin, for `aarch64-darwin` and `x86_64-linux`.

## Usage

### Run directly

```sh
nix run github:yagipass/zabrze-nix
```

### As a flake input

`packages.${system}.zabrze` is built against this flake's pinned nixpkgs.

```nix
{
  inputs.zabrze-nix.url = "github:yagipass/zabrze-nix";
}
```

### As an overlay (build with your nixpkgs)

`overlays.default` builds zabrze against your nixpkgs, sharing dependencies with the rest of your system.

```nix
{
  inputs.zabrze-nix = {
    url = "github:yagipass/zabrze-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

```nix
{ pkgs, ... }:
{
  nixpkgs.overlays = [ zabrze-nix.overlays.default ];
  environment.systemPackages = [ pkgs.zabrze ];
}
```
