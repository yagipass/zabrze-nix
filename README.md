# zabrze-nix

Nix packaging for [Ryooooooga/zabrze](https://github.com/Ryooooooga/zabrze), a zsh abbreviation expansion plugin.
Built for `aarch64-darwin` and `x86_64-linux` by GitHub Actions and pushed to [Cachix](https://app.cachix.org/cache/zabrze-nix).

## Usage

### Run directly

```sh
nix run github:yagipass/zabrze-nix
```

The Cachix cache is offered automatically via the flake's `nixConfig`, so this fetches a prebuilt binary.

### As a flake input (prebuilt via Cachix)

`packages.${system}.zabrze` is built against this flake's pinned nixpkgs, which is exactly what CI pushes to Cachix.

```nix
{
  inputs.zabrze-nix.url = "github:yagipass/zabrze-nix";
  # Do not set inputs.zabrze-nix.inputs.nixpkgs.follows: overriding nixpkgs
  # changes the store paths from what CI built, so the cache would never hit.
}
```

`nixConfig` does not propagate to consumer flakes, so configure the substituter yourself (see [Cachix](#cachix) below).

### As an overlay (build with your nixpkgs)

`overlays.default` builds zabrze against your nixpkgs, sharing dependencies with the rest of your system. The binary cache only hits when your nixpkgs revision matches this flake's, so expect to build from source.

```nix
{
  inputs.zabrze-nix = {
    url = "github:yagipass/zabrze-nix";
    # With the overlay, following your nixpkgs is fine (and keeps flake.lock small).
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

## Cachix

```sh
cachix use zabrze-nix
```

Or configure manually:

- substituter: `https://zabrze-nix.cachix.org`
- public key: `zabrze-nix.cachix.org-1:X36vl+otCAj6rchY63NSY16K/xbyiChWm5gVKtaY0Rg=`
