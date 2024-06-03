{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-bindata,
  installShellFiles,
}:
buildGoModule rec {
  pname = "istioctl";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "1k20s40njm126gfvkm4yhpzk4pqzgyrw8106mchh8iy3f0451f57";
  };
  vendorHash = "07vn8vfswpca22513mvxn3k79xihkizq0rylf5jb3321bs04vwis";

  doCheck = false;

  nativeBuildInputs = [go-bindata installShellFiles];

  # istioctl -> istioctl-1.7.8
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
