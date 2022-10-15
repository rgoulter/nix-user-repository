{pkgs ? import <nixpkgs> {}}: {
  nix = pkgs.mkShell {
    packages = with pkgs; [
      alejandra
      nix
      nix-linter
      rnix-lsp
    ];
  };
}
