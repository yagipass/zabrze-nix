{
  description = "Nix flake packaging zabrze, a zsh abbreviation expansion plugin";

  nixConfig = {
    extra-substituters = [ "https://zabrze-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "zabrze-nix.cachix.org-1:X36vl+otCAj6rchY63NSY16K/xbyiChWm5gVKtaY0Rg="
    ];
  };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (pkgs: rec {
        zabrze = pkgs.callPackage ./package.nix { };
        default = zabrze;
      });

      # Builds zabrze against the consumer's nixpkgs (`final`), so dependencies
      # are shared with their system. Unlike the flake packages, the binary
      # cache only hits when the consumer's nixpkgs revision matches ours.
      overlays.default = final: _prev: {
        zabrze = final.callPackage ./package.nix { };
      };

      checks = eachSystem (pkgs: {
        zabrze = self.packages.${pkgs.stdenv.hostPlatform.system}.zabrze;
      });

      formatter = eachSystem (pkgs: pkgs.nixfmt-tree);
    };
}
