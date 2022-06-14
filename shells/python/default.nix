{ pkgs ? import <nixpkgs> {}
, nixos-2105-pkgs
}:
{
  python_3_6 =
  let
    pkgs = nixos-2105-pkgs;
  in
  pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python36
      python36Packages.pip-tools
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
  python_3_7 = pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python37
      python37Packages.pip-tools
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
  python_3_8 = pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python38
      python38Packages.pip-tools
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
  python_3_9 = pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python39
      python39.pkgs.pip-tools
      python39.pkgs.python-lsp-server
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
  python_3_10 = pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python310
      python310.pkgs.python-lsp-server
      python310.pkgs.pip-tools
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
}
