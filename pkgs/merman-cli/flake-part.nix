_: {
  perSystem = {pkgs, ...}: {
    packages.merman-cli = pkgs.callPackage ./default.nix {};
  };
}
