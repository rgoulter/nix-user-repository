{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-bindata,
  installShellFiles,
}:
buildGoModule rec {
  pname = "istioctl";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "sha256-Vz77hW7mt9ZIC+8PPHru7ix9rWP4UhMsNHA35gRULbs=";
  };
  vendorSha256 = "sha256-9ptxrPBRaGHKX9V8Mz2SHBmaoznpbIlxqh1WkfjgcBc=";

  doCheck = false;

  nativeBuildInputs = [go-bindata installShellFiles];

  # istioctl -> istioctl-1.9.7
  patches = [./istioctl-cmd.patch];

  # Bundle charts
  preBuild = ''
    patchShebangs operator/scripts
    operator/scripts/create_assets_gen.sh
  '';

  # Bundle release metadata
  ldflags = let
    attrs = [
      "istio.io/pkg/version.buildVersion=${version}"
      "istio.io/pkg/version.buildStatus=Nix"
      "istio.io/pkg/version.buildTag=${version}"
      "istio.io/pkg/version.buildHub=docker.io/istio"
    ];
  in ["-s" "-w" "${lib.concatMapStringsSep " " (attr: "-X ${attr}") attrs}"];

  subPackages = ["istioctl/cmd/istioctl"];

  postInstall = ''
    mv $out/bin/istioctl $out/bin/istioctl-${version}
    $out/bin/istioctl-${version} collateral --man --bash --zsh
    installManPage *.1
    installShellCompletion istioctl*.bash
    installShellCompletion --zsh _istioctl*
  '';

  meta = with lib; {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [veehaitch];
    platforms = platforms.unix;
  };
}
