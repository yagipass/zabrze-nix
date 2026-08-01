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

      overlays.default = final: _prev: {
        zabrze = final.callPackage ./package.nix { };
      };

      checks = eachSystem (
        pkgs:
        let
          inherit (pkgs) lib;
          zabrze = self.packages.${pkgs.stdenv.hostPlatform.system}.zabrze;
          nixFiles = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.fileFilter (file: file.hasExt "nix") ./.;
          };
        in
        {
          # The build workflow only runs `nix flake check`, so this check is what
          # builds the package pushed to Cachix. Do not remove it.
          inherit zabrze;

          overlay = (pkgs.extend self.overlays.default).zabrze;

          init-script =
            pkgs.runCommandLocal "zabrze-init-is-valid-zsh" { nativeBuildInputs = [ pkgs.zsh ]; }
              ''
                ${lib.getExe zabrze} init --bind-keys > init.zsh
                zsh -n init.zsh
                touch $out
              '';

          formatting = pkgs.runCommandLocal "check-nix-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            find ${nixFiles} -name '*.nix' -print0 | xargs -0 nixfmt --check
            touch $out
          '';
        }
      );

      formatter = eachSystem (pkgs: pkgs.nixfmt-tree);
    };
}
