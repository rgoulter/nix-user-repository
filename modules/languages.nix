{
  config,
  pkgs,
  lib,
  # e.g. fenix-pkgs = fenix.packages.${system}
  fenix-pkgs,
  ...
}: let
  cfg = config.rgoulter.languages;
  languages = import ../lib/languages {inherit pkgs fenix-pkgs;};
in {
  options.rgoulter.languages = {
    bash.enable = lib.mkEnableOption "packages for bash development";
    go.enable = lib.mkEnableOption "packages for go development";
    haskell.enable = lib.mkEnableOption "packages for haskell development";
    nix.enable = lib.mkEnableOption "packages for nix development";
    nodejs.enable = lib.mkEnableOption "packages for nodejs development";
    python.enable = lib.mkEnableOption "packages for python development";
    rust_thumbv7em-none-eabihf.enable = lib.mkEnableOption "packages for rust development (ARM)";
    rust_wasm32-unknown-unknown.enable = lib.mkEnableOption "packages for rust development (WASM)";
    terraform.enable = lib.mkEnableOption "packages for terraform development";
  };
  config = {
    environment = {
      systemPackages =
        (lib.optionals cfg.bash.enable languages.bash.packages)
        ++ (lib.optionals cfg.go.enable languages.go.packages)
        ++ (lib.optionals cfg.haskell.enable languages.haskell.packages)
        ++ (lib.optionals cfg.nix.enable languages.nix.packages)
        ++ (lib.optionals cfg.nodejs.enable languages.nodejs.packages)
        ++ (lib.optionals cfg.python.enable languages.python.packages)
        ++ (lib.optionals cfg.rust_thumbv7em-none-eabihf.enable languages.rust_thumbv7em-none-eabihf.packages)
        ++ (lib.optionals cfg.rust_wasm32-unknown-unknown.enable languages.rust_wasm32-unknown-unknown.packages)
        ++ (lib.optionals cfg.terraform.enable languages.terraform.packages);
      # python rust
      variables =
        (
          if cfg.rust_thumbv7em-none-eabihf.enable
          then languages.rust_thumbv7em-none-eabihf.environment
          else {}
        )
        // (
          if cfg.rust_wasm32-unknown-unknown.enable
          then languages.rust_wasm32-unknown-unknown.environment
          else {}
        );
    };
  };
}
