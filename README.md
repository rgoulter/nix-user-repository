# nix-user-repository

**My personal [NUR](https://github.com/nix-community/NUR) repository**

Repository based on the [nix-community/nur-packages-template](https://github.com/nix-community/nur-packages-template).

## Outputs

- NixOS Configurations
  - `offline-iso` - ISO/Installer, NixOS configuration with KeePass XC, GnuPG, etc.

- DevShells (Provide compiler/tool, LSP, linting, debugging, etc.; goes well with direnv):
  - go (`go`, `go_1_16`, `go_1_17`, `go_1_18`)
  - python (`python_3_6`, `python_3_7`, `python_3_8`, `python_3_9`, `python_3_10`)
  - rust (`rust_thumbv7em-none-eabihf` for STM32 development, `rust_wasm32-unknown-unknown` for working with Substrate)
  - terraform (`terraform`)

- Packages
  - `myPackages` env with packages I like on my desktop.
  - `devops-env-c` packages I like using for devops.

- Apps
  - Kicad (`kicad5`)
