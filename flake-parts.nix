_: {
  imports = [
    ./flake-parts/devenv.nix
    ./flake-parts/shells.nix
    ./flake-parts/nixos.nix
    ./flake-parts/treefmt.nix
    ./pkgs/flake-part.nix
  ];
}
