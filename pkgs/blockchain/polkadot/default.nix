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
in let
  name = "polkadot";
  version = "0.9.37";
in
  naersk'.buildPackage ({
      inherit name version;
      src = pkgs.fetchFromGitHub {
        owner = "paritytech";
        repo = name;
        rev = "v${version}";
        sha256 = "sha256-TTi4cKqQT/2ZZ/acGvcilqTlh2D9t4cfAtQQyVZWdmg";
      };
      buildInputs = language-rust.packages;
    }
    // language-rust.environment)
