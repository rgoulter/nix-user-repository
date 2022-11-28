{
  pkgs,
  fenix,
  naersk,
}: let
  target = "wasm32-unknown-unknown";
  nightly = fenix.toolchainOf {
    channel = "nightly";
    date = "2022-06-22";
    sha256 = "sha256-d1n/U+0DFbBnSF3IQHKCLeh2oITVXhghMtKwXQGEhgg=";
  };
  toolchain = with fenix;
    combine [
      nightly.defaultToolchain
      nightly.rust-src
      (targets.${target}.toolchainOf {
        channel = "nightly";
        date = "2022-06-22";
        sha256 = "sha256-d1n/U+0DFbBnSF3IQHKCLeh2oITVXhghMtKwXQGEhgg=";
      })
      .rust-std
    ];
  naersk' = pkgs.callPackage naersk {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  naersk'.buildPackage {
    src = pkgs.fetchFromGitHub {
      owner = "paritytech";
      repo = "polkadot";
      rev = "v9.30.0";
      sha256 = "3hmoTTzdvC1s0GsfgEz6vaIh/obx+MHCqjnUJR6NRVk=";
    };
    buildInputs = [
      pkgs.clang
      pkgs.pkg-config
      pkgs.rust-analyzer
      pkgs.pkg-config
    ];
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    PROTOC = "${pkgs.protobuf}/bin/protoc";
    ROCKSDB_LIB_DIR = "${pkgs.rocksdb}/lib";
    RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library/";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig/"; # for cargo-contract
  }
