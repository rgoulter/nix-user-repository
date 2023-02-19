{
  pkgs,
  languages,
  naersk,
}: let
  language-rust = languages.rust_wasm32-unknown-unknown;
  naersk' = pkgs.callPackage naersk {
    cargo = language-rust.toolchain;
    rustc = language-rust.toolchain;
  };
in
  naersk'.buildPackage ({
    src = pkgs.fetchFromGitHub {
      owner = "paritytech";
      repo = "polkadot";
      rev = "v0.9.30";
      sha256 = "sha256-3hmoTTzdvC1s0GsfgEz6vaIh/obx+MHCqjnUJR6NRVk";
    };
    buildInputs = language-rust.packages;
  } // language-rust.environment)
