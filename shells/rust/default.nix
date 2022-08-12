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

  rust_wasm32-unknown-unknown =
    let
      target = "wasm32-unknown-unknown";
      nightly = fenix-pkgs.toolchainOf {
          channel = "nightly";
          date = "2022-04-20";
          sha256 = "sha256-nJgASSAqGkaJ9svoIYVVYrw+YLF4E6AnG02nThtWXDo=";
        };
      toolchain = with fenix-pkgs;
        combine [
          nightly.defaultToolchain
          nightly.rust-src
          (targets.${target}.toolchainOf {
            channel = "nightly";
            date = "2022-04-20";
            sha256 = "sha256-nJgASSAqGkaJ9svoIYVVYrw+YLF4E6AnG02nThtWXDo=";
          }).rust-std
        ];
    in
    pkgs.mkShell {
      buildInputs = [
        pkgs.clang
        pkgs.pkg-config
        pkgs.rust-analyzer
        toolchain
      ];

      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      PROTOC = "${pkgs.protobuf}/bin/protoc";
      ROCKSDB_LIB_DIR = "${pkgs.rocksdb}/lib";
      RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library/";
    };
}
