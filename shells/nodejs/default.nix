{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  nodejs = pkgs.mkShell {
    inherit (languages.nodejs) packages;
  };
}
