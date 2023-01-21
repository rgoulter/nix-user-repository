{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  bash = pkgs.mkShell {
    inherit (languages.bash) packages;
  };
}
