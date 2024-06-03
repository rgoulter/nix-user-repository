{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  python_3_10 = pkgs.mkShell {
    inherit (languages.python) packages;
    inherit (languages.python.environment) LD_LIBRARY_PATH;
  };
}
