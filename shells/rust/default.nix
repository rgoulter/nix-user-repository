{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  rust = pkgs.mkShell {
    inherit
      (languages.rust.environment)
      LIBCLANG_PATH
      PKG_CONFIG_PATH
      PROTOC
      ROCKSDB_LIB_DIR
      RUST_SRC_PATH
      ;
    nativeBuildInputs = languages.rust.packages ++ [pkgs.cmake];
  };

  rust_thumbv7em-none-eabihf_stable = pkgs.mkShell {
    inherit (languages.rust_thumbv7em-none-eabihf_stable.environment) RUSTC RUST_SRC_PATH;
    nativeBuildInputs = languages.rust_thumbv7em-none-eabihf_stable.packages;
  };

  rust_thumbv7em-none-eabihf = pkgs.mkShell {
    inherit (languages.rust_thumbv7em-none-eabihf.environment) RUSTC RUST_SRC_PATH;
    nativeBuildInputs = languages.rust_thumbv7em-none-eabihf.packages;
  };
}
