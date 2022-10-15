{pkgs ? import <nixpkgs> {}}: {
  bash = pkgs.mkShell {
    packages = with pkgs; [
      fd
      fzf
      jq
      just
      pre-commit
      ripgrep
      treefmt
    ];
  };
}
