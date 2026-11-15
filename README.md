# nix-user-repository

**My personal [NUR](https://github.com/nix-community/NUR) repository**

Repository based on the [nix-community/nur-packages-template](https://github.com/nix-community/nur-packages-template).

## Outputs

- NixOS Configurations
  - `offline` - air-gapped NixOS configuration with GnuPG, paperkey, KeePassXC, etc.

- DevShells (Provide compiler/tool, LSP, linting, debugging, etc.; goes well with direnv):
  - go (`go`, `go_1_16`, `go_1_17`, `go_1_18`)
  - python (`python_3_6`, `python_3_7`, `python_3_8`, `python_3_9`, `python_3_10`)
  - rust (`rust_thumbv7em-none-eabihf` for STM32 development, `rust_wasm32-unknown-unknown` for working with Substrate)
  - terraform (`terraform`)

- Packages
  - `offline-iso` - bootable ISO of the `offline` NixOS configuration, for managing GnuPG keys.
  - `workstation` env with packages I like on my desktop (`myPackages` is a deprecated alias).
  - `devops-env-c` packages I like using for devops.
  - `mmdflux` — headless Mermaid → terminal text, SVG, MMDS JSON ([kevinswiber/mmdflux](https://github.com/kevinswiber/mmdflux)).
  - `merman-cli` — headless Mermaid.js renderer for SVG, raster, and terminal output ([Latias94/merman](https://github.com/Latias94/merman)).
- `llm-agents` — buildEnv of LLM coding-agent CLIs from [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix): `grok` (Grok Build), `codex` (OpenAI Codex TUI), `chatgpt` (ChatGPT/Codex desktop), `copilot-cli`, `claude-code`. Uses the numtide binary cache (`cache.numtide.com`).

## Using NixOS Modules in a NixOS Configuration

A `flake.nix` making use of the NixOS modules might look like:

``` nix
{
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    rgoulter.url = "github:rgoulter/nix-user-repository";
  };

  outputs = { self, nixos-hardware, nixpkgs, rgoulter }: {
    nixosConfigurations = {
      YOUR-HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          rgoulter.nixosModules.bluetooth-headset
          rgoulter.nixosModules.virtualization
          # etc.
          self.nixosModules.system-hardware
        ];
      };
    };
    nixosModules = {
      system-hardware = import ./hardware-desktop.nix { inherit nixos-hardware; };
    };
  };
}
```

e.g. where `hardware-desktop.nix` may be something like:

``` nix
{ nixos-hardware }:

{
  imports =
    [
      nixos-hardware.nixosModules.common-cpu-intel-cpu-only
      nixos-hardware.nixosModules.common-gpu-nvidia
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd
    ];
}
```

On a computer with hostname `YOUR-HOSTNAME`, this can then be built with:

``` sh
$ nixos-rebuild build --flake .
```

or to set as the default boot entry:

``` sh
# nixos-rebuild boot --flake .
```

If using [specialisations](https://nixos.wiki/wiki/Specialisation) (e.g. the
`desktops` module), note that the command to switch configuration is, e.g. for `gnome`:

``` sh
/nix/var/nix/profiles/system/specialisation/gnome/bin/switch-to-configuration switch
```

## The 'Offline' NixOS Configuration

The `offline` configuration is an air-gapped system for managing GnuPG keys.
It is booted from a USB drive, away from the main installation.
Networking is disabled, and printing is kept for paperkey backups.

The image includes `gpg-extend-expiry`, which extends the expiry of a key and its subkeys and exports the public key.
The `offline-gpg` command runs a justfile of common GnuPG tasks; `offline-gpg --list` lists them.
Run `man offline-gpg` on the image for the full procedure.

Build the ISO with

``` sh
nix build .#offline-iso
```

The ISO is written to `result/iso/`.
It can be copied to a thumbdrive (e.g. with [Ventoy](https://www.ventoy.net/en/index.html)).

To try the ISO in QEMU without root:

``` sh
nix run nixpkgs#qemu -- -m 4G -smp 2 -nic none -vga virtio -cdrom result/iso/*.iso -boot d
```

Add `-enable-kvm` where `/dev/kvm` is available.

For faster iteration, build and run the configuration as a VM:

``` sh
nix build .#nixosConfigurations.offline.config.system.build.vm
./result/bin/run-*-vm
```

The VM keeps its state in a `nixos.qcow2` file in the current directory.
Delete this file after changing the `offline.nix` module, so that the VM starts from a fresh disk.
