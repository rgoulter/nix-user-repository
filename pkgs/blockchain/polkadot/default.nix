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
      rev = "v0.9.37";
      sha256 = "sha256-TTi4cKqQT/2ZZ/acGvcilqTlh2D9t4cfAtQQyVZWdmg";
    };
    buildInputs = language-rust.packages;
  } // language-rust.environment)
