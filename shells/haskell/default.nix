{pkgs ? import <nixpkgs> {}}: {
  haskell = pkgs.mkShell {
    packages = with pkgs; [
      ghcid
      haskell-language-server
      ormolu
    ];
  };
}
