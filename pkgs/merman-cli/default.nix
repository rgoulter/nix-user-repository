{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "merman-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Latias94";
    repo = "merman";
    rev = "v${version}";
    hash = "sha256-PzGHYRUlLjica0OTWcz4BwUJz0ci/FrOabkranOr9gU=";
  };

  cargoHash = "sha256-FKqDPDOBfePUby8rFBflLyhEBrHTbeGhNCdZviNnfts=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  cargoBuildFlags = ["-p" "merman-cli"];
  cargoTestFlags = ["-p" "merman-cli"];

  # Workspace e2e tests (e.g. merman-rustdoc) need rustdoc on PATH; smoke-test via package use instead.
  doCheck = false;

  meta = with lib; {
    description = "Headless Mermaid.js renderer for SVG, raster, and terminal output";
    homepage = "https://github.com/Latias94/merman";
    license = with licenses; [mit asl20];
    maintainers = [];
    mainProgram = "merman-cli";
  };
}
