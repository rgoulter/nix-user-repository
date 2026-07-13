{inputs, ...}: {
  imports = [
    ./mmdflux/flake-part.nix
    ./merman-cli/flake-part.nix
  ];

  perSystem = {
    pkgs,
    system,
    ...
  }: let
    pkgsUnfree = import ../lib/unfree-pkgs.nix {
      nixpkgs = inputs.nixpkgs;
      inherit system;
    };
    makeEmacsChemacsProfile =
      pkgs.callPackage ../lib/make-emacs-chemacs-profile-application.nix {};
    workstation = import ./workstation {
      inherit makeEmacsChemacsProfile;
      pkgs = pkgsUnfree;
    };
    workstation-lite = import ./workstation/lite.nix {
      inherit makeEmacsChemacsProfile;
      pkgs = pkgsUnfree;
    };
  in {
    packages = {
      default = workstation;
      inherit workstation workstation-lite;
      myPackages = pkgs.lib.warn "myPackages is deprecated; use workstation instead." workstation;
      myPackages-lite =
        pkgs.lib.warn "myPackages-lite is deprecated; use workstation-lite instead."
        workstation-lite;
    };
  };
}
