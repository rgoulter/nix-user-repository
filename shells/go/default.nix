{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  go = pkgs.mkShell {
    inherit (languages.go) packages;
  };
}
