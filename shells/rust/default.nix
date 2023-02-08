{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  rust = pkgs.mkShell {
    inherit (languages.rust.environment) RUST_SRC_PATH;
    nativeBuildInputs = languages.rust.packages ++ [ pkgs.cmake ];
  };

  rust_thumbv7em-none-eabihf = pkgs.mkShell {
    inherit (languages.rust_thumbv7em-none-eabihf.environment) RUST_SRC_PATH;
    nativeBuildInputs = languages.rust_thumbv7em-none-eabihf.packages;
  };

  rust_wasm32-unknown-unknown = pkgs.mkShell {
    inherit
      (languages.rust_wasm32-unknown-unknown.environment)
      LIBCLANG_PATH
      PKG_CONFIG_PATH
      PROTOC
      ROCKSDB_LIB_DIR
      RUST_SRC_PATH
      ;
    buildInputs = languages.rust_wasm32-unknown-unknown.packages;
  };
}
