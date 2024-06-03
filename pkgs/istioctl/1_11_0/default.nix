{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "istioctl";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "sha256-pQ8Xhhjpcp9RAUUqEDNWRf9JI7xkDVh2PG2KB0lmScs=";
  };
  vendorHash = "sha256-PBMPTrTk5AzzELitSVQijHnx8YDCiZ7R+cpetUfe2KU=";

  nativeBuildInputs = [installShellFiles];

  # istioctl -> istioctl-1.11.0
  patches = [./istioctl-cmd.patch];

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
    maintainers = with maintainers; [superherointj bryanasdev000 veehaitch];
    platforms = platforms.unix;
  };
}
