{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  terraform = pkgs.mkShell {
    inherit (languages.terraform) packages;
  };
}
