{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  nix = pkgs.mkShell {
    inherit (languages.nix) packages;
  };
}
