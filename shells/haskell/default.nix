{pkgs ? import <nixpkgs> {}}: {
  haskell = pkgs.mkShell {
    packages = with pkgs; [
      cabal-fmt
      ghcid
      haskell-language-server
      ormolu
    ];
  };
}

