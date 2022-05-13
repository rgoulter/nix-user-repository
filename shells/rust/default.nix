{ pkgs ? import <nixpkgs> {}
, fenix-pkgs ?
    import (
     fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"
    ) {}
}:

{
  rust_thumbv7em-none-eabihf =
    let
      target = "thumbv7em-none-eabihf";
      toolchain = with fenix-pkgs;
        combine [
          complete.llvm-tools-preview
          complete.rust-src
          default.rustfmt
          default.cargo
          default.rustc
          targets.${target}.latest.rust-std
        ];
    in
    pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.rust-analyzer
        toolchain
      ];
      RUST_SRC_PATH="${toolchain}/lib/rustlib/src";
    };
}
