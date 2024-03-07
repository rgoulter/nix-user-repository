{
  pkgs,
  fenix-pkgs,
}: let
  languages = import ../lib/languages {inherit fenix-pkgs pkgs;};
in
  import ./bash {inherit languages pkgs;}
  // import ./development {inherit pkgs;}
  // import ./go {inherit languages pkgs;}
  // import ./haskell {inherit languages pkgs;}
  // import ./nix {inherit languages pkgs;}
  // import ./nodejs {inherit languages pkgs;}
  // import ./opentofu {inherit languages pkgs;}
  // import ./python {inherit languages pkgs;}
  // import ./rust {inherit languages pkgs;}
  // import ./terraform {inherit languages pkgs;}
