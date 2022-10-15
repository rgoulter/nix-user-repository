{pkgs ? import <nixpkgs> {}}: {
  bash = pkgs.mkShell {
    packages = with pkgs; [
      bashInteractive
      nodePackages.bash-language-server
      shellcheck
      shfmt
    ];
  };
}
