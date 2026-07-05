{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "mmdflux";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "kevinswiber";
    repo = "mmdflux";
    rev = "mmdflux-v${version}";
    hash = "sha256-xpgH/xo8WtxEGPqxAdmJjb5Lld11yMNkwOg4FIAdzk4=";
  };

  cargoHash = "sha256-FSncQS/02/pzSEM4MLSK02GosmU/yVQ7fhmOPPF1UaM=";

  buildFeatures = ["cli"];

  meta = with lib; {
    description = "Render Mermaid diagrams as terminal text, SVG, and structured JSON";
    homepage = "https://github.com/kevinswiber/mmdflux";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "mmdflux";
  };
}
