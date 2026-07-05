_: {
  perSystem = {pkgs, ...}: {
    packages.mmdflux = pkgs.callPackage ./default.nix {};
  };
}
