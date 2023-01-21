{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
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
    inherit (languages.python) packages;
    inherit (languages.python.environment) LD_LIBRARY_PATH;
  };
}
