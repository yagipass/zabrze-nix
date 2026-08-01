{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "ZSH abbreviation expansion plugin";
    homepage = "https://github.com/Ryooooooga/zabrze";
    license = lib.licenses.mit;
    mainProgram = "zabrze";
  };
}
