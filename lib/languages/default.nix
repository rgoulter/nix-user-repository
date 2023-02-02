# Attribute sets of languages
# with packages to install.
#
# To share with both devShells (for `use flake`)
# and buildEnv / nixos modules.
{
  pkgs,
  fenix-pkgs,
  ...
}: {
  bash = {
    packages = with pkgs; [
      bashInteractive
      nodePackages.bash-language-server
      shellcheck
      shfmt
    ];
  };
  go = {
    packages = with pkgs; [
      go
      gopls
    ];
  };
  haskell = {
    packages = with pkgs; [
      ghcid
      haskell-language-server
      ormolu
    ];
  };
  nix = {
    packages = with pkgs; [
      alejandra
      nix
      nix-linter
      rnix-lsp
    ];
  };
  nodejs = {
    packages = with pkgs; [
      nodejs
      nodePackages.eslint
      nodePackages.typescript
      nodePackages.typescript-language-server
      yarn
    ];
  };
  python = {
    # this was set for the `mkShell`
    environment = {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
      ];
    };
    packages = with pkgs; [
      libffi
      python310
      python310.pkgs.python-lsp-server
      pyright
    ];
  };
  rust_thumbv7em-none-eabihf = let
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
  in {
    inherit toolchain;
    environment = {
      RUST_SRC_PATH = "${toolchain}/lib/rustlib/src";
    };
    packages = with pkgs; [
      pkgs.rust-analyzer
      toolchain
    ];
  };
  rust_wasm32-unknown-unknown = let
    toolchain = with fenix-pkgs;
      fromToolchainFile {
        file = ./rust-toolchain.toml;
        sha256 = "sha256-FK01QQuXkFXuy/W7wzAA0G+T2s9dQIDBjMxMC0cUk2M=";
      };
  in {
    inherit toolchain;
    environment = {
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig/"; # for cargo-contract
      PROTOC = "${pkgs.protobuf}/bin/protoc";
      ROCKSDB_LIB_DIR = "${pkgs.rocksdb}/lib";
      RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library/";
    };
    packages = with pkgs; [
      pkgs.clang
      pkgs.pkg-config
      pkgs.rust-analyzer
      toolchain
      pkgs.openssl # for cargo-dylint
      # binaryen # for cargo contracts
    ];
  };
  terraform = {
    packages = with pkgs; [
      terraform
      terraform-ls
      tflint
    ];
  };
}