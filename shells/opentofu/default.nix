{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  opentofu = pkgs.mkShell {
    inherit (languages.opentofu) packages;
  };
}
