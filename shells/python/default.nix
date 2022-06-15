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
      cargo
      libffi
      python36
      pyright
      rustc
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
  python_3_7 = pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python37
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
      pyright
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
  };
}
