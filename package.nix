# version / hash / cargoHash は nix-update で更新する(update workflow が週次で実行)。
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zabrze";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Ryooooooga";
    repo = "zabrze";
    tag = "v${version}";
    hash = "sha256-OmwU7/SQqEAzZo7/Eix3yc+VLEU6+/NIiALvpU3PlKA=";
  };

  cargoHash = "sha256-9UZSOXTWvX9jPE0crGb/hUpemuVhEGgyzs+HL3QwIgg=";

  cargoTestFlags = [ "--bins" ];

  meta = {
    description = "ZSH abbreviation expansion plugin";
    homepage = "https://github.com/Ryooooooga/zabrze";
    license = lib.licenses.mit;
    mainProgram = "zabrze";
  };
}
