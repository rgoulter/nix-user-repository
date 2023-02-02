{
  pkgs,
  fenix-pkgs,
  ...
}: {
  languages = import ./languages {inherit pkgs fenix-pkgs;};
}
