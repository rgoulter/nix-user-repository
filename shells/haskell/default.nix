{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  haskell = pkgs.mkShell {
    inherit (languages.haskell) packages;
  };
}
