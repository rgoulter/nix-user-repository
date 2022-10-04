{ nixos-2105-pkgs
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
}
